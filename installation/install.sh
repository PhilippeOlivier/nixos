#!/usr/bin/env -S bash -e

set -e

DEVICE="/dev/nvme0n1"
BOOT_LABEL="BOOT"
ROOT_LABEL="ROOT"
BOOT_PARTITION="/dev/disk/by-partlabel/${BOOT_LABEL}"
ROOT_PARTITION="/dev/disk/by-partlabel/${ROOT_LABEL}"
LUKS_MAPPING="cryptroot"
CRYPTROOT="/dev/mapper/${LUKS_MAPPING}"
POOL="tank"

# Delete the filesystem
sudo wipefs -af $DEVICE

# Delete the partition table
sudo sgdisk -Zo $DEVICE

# Partition the device
sudo parted -s $DEVICE \
     mklabel gpt \
     mkpart $BOOT_LABEL fat32 1MiB 1GiB \
     set 1 esp on \
     mkpart $ROOT_LABEL 1GiB 100%

# Inform the kernel of changes
sudo partprobe $DEVICE

# Boot partition
sudo mkfs.fat -F 32 -n $BOOT_LABEL $BOOT_PARTITION
sudo mlabel -N 20240207 -i $BOOT_PARTITION ::

# LUKS
read -r -s -p "Enter a password for the LUKS container: " LUKS_PASSPHRASE
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup luksFormat --uuid 20240207-0000-0000-d6d9-000000000000 --type luks2 $ROOT_PARTITION -d -
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup open --type luks2 --allow-discards $ROOT_PARTITION $LUKS_MAPPING -d -

# ZFS pool
sudo zpool create \
     -O acltype=posixacl \
     -o ashift=12 \
     -o autotrim=on \
     -O compression=lz4 \
     -O mountpoint=none \
     -O xattr=sa \
     $POOL /dev/mapper/cryptroot

# ZFS datasets
sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/root
sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/nix
sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/var
sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true ${POOL}/home
sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/home/nosnap

# Mount
sudo mount -t zfs ${POOL}/root /mnt

sudo mkdir -p /mnt/boot
sudo mount $BOOT_PARTITION /mnt/boot

sudo mkdir -p /mnt/nix
sudo mount -t zfs ${POOL}/nix /mnt/nix

sudo mkdir -p /mnt/var
sudo mount -t zfs ${POOL}/var /mnt/var

sudo mkdir -p /mnt/home
sudo mount -t zfs ${POOL}/home /mnt/home
sudo mkdir -p /mnt/home/pholi/.nosnap
sudo chown pholi:users /mnt/home/pholi/.nosnap
sudo mount -t zfs ${POOL}/home/nosnap /mnt/home/pholi/.nosnap

# Generate basic configuration, including `hardware-configuration.nix`
sudo nixos-generate-config --root /mnt

# Add the cryptroot device to `hardware-configuration.nix`
sudo sed -i '/.*boot.extraModulePackages.*/a boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/20240207-0000-0000-d6d9-000000000000";' /mnt/etc/nixos/hardware-configuration.nix

# Add `networking.hostId` for ZFS (note: change this value for other machines)
sudo sed -i '/.*boot.extraModulePackages.*/a networking.hostId = "a8c49b83";' /mnt/etc/nixos/hardware-configuration.nix

# Replace the default `configuration.nix` with my shim
cat > configuration.nix <<EOF
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader = {
    systemd-boot = {
      enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "pholi-nixos";
    wireless.enable = true;
    wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
    useDHCP = false;
    interfaces = {
      wlp4s0 = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.0.81";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };

  # Users
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    password = "asdf";
  };
  
  users.users.pholi = {
    isNormalUser = true;
    password = "asdf";
    description = "Philippe Olivier";
    home = "/home/pholi";
    extraGroups = [
      "wheel"
    ];
  };

  # ZFS
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Misc
  system.stateVersion = "24.05";
  environment.systemPackages = [
    pkgs.git
  ];
}
EOF

sudo mv configuration.nix /mnt/etc/nixos/configuration.nix

# Install NixOS
sudo nixos-install --root /mnt --no-root-password

echo "Complete. Reboot and follow the last README instructions."

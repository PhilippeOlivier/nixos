#!/usr/bin/env -S bash -e

set -e

WIRELESS_DEVICE="wlp4s0"
DEVICE="/dev/nvme0n1"
BOOT_LABEL="BOOT"
ROOT_LABEL="ROOT"
LUKS_LABEL="CRYPTROOT"
BOOT_PARTITION="/dev/disk/by-partlabel/${BOOT_LABEL}"
ROOT_PARTITION="/dev/disk/by-partlabel/${ROOT_LABEL}"
LUKS_MAPPING="cryptroot"
CRYPTROOT="/dev/mapper/${LUKS_MAPPING}"
POOL="tank"

wpa_passphrase $(cat /home/nixos/install/ssid) $(cat /home/nixos/install/password) | sudo wpa_supplicant -B -i $WIRELESS_DEVICE -c /dev/stdin

# Partition the device
sudo parted -s -a optimal $DEVICE \
     mklabel gpt \
     mkpart $BOOT_LABEL fat32 0% 1GiB \
     set 1 esp on \
     mkpart $ROOT_LABEL 1GiB 100%

# Boot partition
sudo mkfs.vfat $BOOT_PARTITION

# LUKS
read -r -s -p "Enter a password for the LUKS container: " LUKS_PASSPHRASE
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup luksFormat --label $LUKS_LABEL --type luks2 $ROOT_PARTITION -d -
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup open --type luks2 --allow-discards $ROOT_PARTITION $LUKS_MAPPING -d -

# ZFS pool
sudo zpool create \
     -O acltype=posixacl \
     -o ashift=12 \
     -o autotrim=on \
     -O compression=lz4 \
     -O mountpoint=none \
     -O xattr=sa \
     $POOL $CRYPTROOT

# ZFS datasets

sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/root
sudo zfs snapshot ${POOL}/root@blank
sudo mount -t zfs ${POOL}/root /mnt

sudo mkdir -p /mnt/boot
sudo mount $BOOT_PARTITION /mnt/boot

sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/nix
sudo mkdir -p /mnt/nix
sudo mount -t zfs ${POOL}/nix /mnt/nix

sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=true ${POOL}/snap
sudo mkdir -p /mnt/snap
sudo mount -t zfs ${POOL}/snap /mnt/snap

sudo zfs create -o mountpoint=legacy -o com.sun:auto-snapshot=false ${POOL}/nosnap
sudo mkdir -p /mnt/nosnap
sudo mount -t zfs ${POOL}/nosnap /mnt/nosnap

# Create a very simple `configuration.nix`
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
      $WIRELESS_DEVICE = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.100.100";
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
    pkgs.cryptsetup
    pkgs.git
  ];
}
EOF

# Install NixOS
sudo mkdir -p /mnt/etc/nixos
sudo cp configuration.nix temp/test/config/hardware-configuration.nix /mnt/etc/nixos
sudo nixos-install --root /mnt --no-root-password

# Copy `test` to the new home directory
mkdir /mnt/home/pholi/nixos
cp -r temp/test /mnt/home/pholi/nixos

# Unmount the USB drive containing the `test` directory
sudo umount temp

# Get rid of `/etc/nixos`:
sudo rm -rf /mnt/etc/nixos

sudo reboot

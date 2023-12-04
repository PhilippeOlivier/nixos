#!/usr/bin/env -S bash -e

set -e

# To create the bootable USB image, download the latest unstable ISO here:
# https://releases.nixos.org/nixos/unstable/nixos-24.05pre554114.e92039b55bcd
# Then:
# sudo dd if=nixos-minimal-....-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
#
# To setup internet during installation:
# wpa_passphrase SSID PASSWORD | sudo wpa_supplicant -B -i INTERFACE -c /dev/stdin
#
# To launch this script:
# bash <(curl -sL raw.githubusercontent.com/PhilippeOlivier/nixos-config/main/nixos.sh)

DEVICE="/dev/nvme0n1"
RAM="$(free -m | sed -n '2p' | sed 's/[^0-9]*//' | cut -d' ' -f1)"
BOOT_LABEL="BOOT"
SWAP_LABEL="SWAP"
ROOT_LABEL="NIXOS"
BOOT_PARTITION="/dev/disk/by-partlabel/${BOOT_LABEL}"
SWAP_PARTITION="/dev/disk/by-partlabel/${SWAP_LABEL}"
ROOT_PARTITION="/dev/disk/by-partlabel/${ROOT_LABEL}"
LUKS_MAPPING="cryptroot"
CRYPTROOT="/dev/mapper/${LUKS_MAPPING}"

# Delete the filesystem
sudo wipefs -af "$DEVICE"

# Delete the partition table
sudo sgdisk -Zo "$DEVICE"

# Partition the device (SWAP will be equal to the available RAM)
sudo parted -s "$DEVICE" \
     mklabel gpt \
     mkpart $BOOT_LABEL fat32 1MiB 513MiB \
     set 1 esp on \
     mkpart $SWAP_LABEL linux-swap 513MiB $(( 513 + RAM ))MiB \
     mkpart $ROOT_LABEL ext4 $(( 513 + RAM ))MiB 100%

# Inform the kernel of changes
sudo partprobe "$DEVICE"

# Create the filesystems
sudo mkfs.fat -F 32 -n $BOOT_LABEL $BOOT_PARTITION
sudo mkswap -L $SWAP_LABEL $SWAP_PARTITION
sudo swapon $SWAP_PARTITION
read -r -s -p "Enter a password for the LUKS container: " LUKS_PASSPHRASE
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup luksFormat --type luks2 "$ROOT_PARTITION" -d -
echo -n "$LUKS_PASSPHRASE" | sudo cryptsetup open --type luks2 "$ROOT_PARTITION" "$LUKS_MAPPING" -d -
sudo mkfs.ext4 -L $LUKS_MAPPING $CRYPTROOT

# Mount partitions
sudo mount $CRYPTROOT /mnt
sudo mkdir -p /mnt/boot
sudo mount $BOOT_PARTITION /mnt/boot

# TODO: The below steps will be manual

# Generate `hardware-configuration.nix`
sudo nixos-generate-config --root /mnt

# Overwrite `configuration.nix` with my personal config file
curl -LOo main.zip https://github.com/PhilippeOlivier/nixos-config/archive/main.zip
unzip main.zip
sudo mv nixos-config-main/* /mnt/etc/nixos
# rm nixos-config.zip
# sudo curl -sLo /mnt/etc/nixos/configuration.nix pedtsr.ca/homelab/configuration.nix

# Install NixOS
sudo nixos-install --root /mnt --no-root-password

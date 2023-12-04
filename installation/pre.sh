#!/usr/bin/env -S bash -e

set -e

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

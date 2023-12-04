# NixOS installation

To create the bootable USB image, download the latest unstable ISO here:

https://releases.nixos.org/nixos/unstable/nixos-24.05pre554114.e92039b55bcd

```bash
$ sudo dd if=nixos-minimal-....-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

Boot from the USB drive, then setup internet for the installation:

```bash
$ wpa_passphrase SSID PASSWORD | sudo wpa_supplicant -B -i INTERFACE -c /dev/stdin
```

#
# sudo rm /etc/nixos
# sudo ln -s /home/pholi/nixos /etc/nixos
#
# To launch this script:
# bash <(curl -sL raw.githubusercontent.com/PhilippeOlivier/nixos/main/nixos.sh)


With `lsblk` validate that the value of `DEVICE` is the correct one.

# TODO: The below steps will be manual

# Generate `hardware-configuration.nix`
sudo nixos-generate-config --root /mnt

backup hardware-configuration.nix

# Overwrite `configuration.nix` with my personal config file
curl -LOo main.zip https://github.com/PhilippeOlivier/nixos-config/archive/main.zip
unzip main.zip
sudo mv nixos-config-main/* /mnt/etc/nixos
# rm nixos-config.zip
# sudo curl -sLo /mnt/etc/nixos/configuration.nix pedtsr.ca/homelab/configuration.nix

# Install NixOS
sudo nixos-install --root /mnt --no-root-password

sudo ln -s /home/pholi/nixos /etc/nixos

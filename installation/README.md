# NixOS installation

To create the bootable USB image, download the latest unstable ISO here:

https://releases.nixos.org/nixos/unstable/nixos-24.05pre554114.e92039b55bcd

```bash
$ sudo dd if=nixos-minimal-....-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

BIOS:
- Make sure it is updated.
- Disable secure boot.
- Enable virtualization.

Boot from the USB drive, then setup internet for the installation:

```bash
$ wpa_passphrase SSID PASSWORD | sudo wpa_supplicant -B -i INTERFACE -c /dev/stdin
```

With `lsblk` validate that the value of `DEVICE` in `installation/install.sh` is the correct one. Also, with `ifconfig` make sure that the network interface is correct in `installation/install.sh`.

Fetch the Bash script to partition and format the disk:

```bash
$ curl -sLo install.sh raw.githubusercontent.com/PhilippeOlivier/nixos/main/installation/install.sh
```

Launch the script. You will be prompted for the LUKS password at some point. When the script finishes, reboot.

```bash
$ bash install.sh
```

Login locally or using SSH (192.168.0.81).

Clone my personal configuration (normally, replace `hardware-configuration.nix` in it with the new one) and get rid of `/etc/nixos`:

```bash
$ git clone https://github.com/PhilippeOlivier/nixos.git
$ sudo cp /etc/nixos/hardware-configuration nixos
$ sudo rm -rf /etc/nixos
```

Copy the backup `.nixos-extra` directory to `~/.nixos-extra`.

Rebuild:

```bash
$ sudo nixos-rebuild switch --flake /home/pholi/nixos
```

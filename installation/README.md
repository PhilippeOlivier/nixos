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

With `lsblk` validate that the value of `DEVICE` in `installation/pre.sh` is the correct one.

Fetch the Bash script to partition and format the disk:

```bash
$ curl -sLo pre.sh raw.githubusercontent.com/PhilippeOlivier/nixos/main/installation/pre.sh
```

Launch the script. You will be prompted for the LUKS password at some point:

```bash
$ bash pre.sh
```

Optional: If this is a new computer, generate a basic configuration in order to get `hardware-configuration.nix` (and replace the `hardware-configuration.nix` from the git repo):

```bash
$ sudo nixos-generate-config --root /mnt
```

Fetch my personal configuration:

```bash
$ curl -LO https://github.com/PhilippeOlivier/nixos/archive/main.zip
$ unzip main.zip
$ sudo mv nixos-main/* /mnt/etc/nixos
```

Install NixOS:

```bash
$ sudo nixos-install --root /mnt --no-root-password
```

Reboot. Clone my personal configuration (optionally, replace `hardware-configuration.nix` in it with the new one) and get rid of `/etc/nixos`:

```bash
$ git clone https://github.com/PhilippeOlivier/nixos.git
$ sudo rm -rf /etc/nixos
```

Rebuild:

```bash
$ sudo nixos-rebuild switch --flake /home/pholi/nixos
```

# NixOS installation

To create the bootable USB image, download the latest unstable ISO here:

https://releases.nixos.org/?prefix=nixos/unstable/

```bash
$ sudo dd if=nixos-minimal-....-x86_64-linux.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
```

BIOS:
- Make sure it is updated.
- Disable secure boot.
- Enable virtualization.

Boot from the USB drive (press F12 during startup).

Copy `~/nixos/framework` to another USB drive, then mount it:

```bash
$ mkdir temp
$ sudo mount /dev/sdX1 temp
$ cp -r temp/framework/install .
```

In `install/install.sh`, validate that the disk device is the correct one (with `lsblk`) and validate that the network device is the correct one (with `ip link`). If this is a new machine, you might want to create a new `hardware-configuration.nix`. Put the SSID and password of the wifi network in `install/ssid` and `install/password`. Launch the script:

```bash
$ bash install/install.sh
```

You will be prompted for the LUKS password. The script is complete when the machine reboots.

After the reboot, change the ownership of `/home/pholi`:

```bash
$ sudo chown -R pholi:users /home/pholi
```

Rebuild with the real configuration:

```bash
$ sudo nixos-rebuild switch --flake /home/pholi/nixos/framework/config
```

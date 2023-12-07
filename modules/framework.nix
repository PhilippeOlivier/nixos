{ config, pkgs, ... }:

{
  # Most of these are Framework/Intel-specific settings, as detailed here: https://github.com/NixOS/nixos-hardware
  #
  # More specifically:
  # /framework/13-inch/12th-gen-intel/default.nix
  # /framework/13-inch/common/default.nix
  # /framework/13-inch/common/intel.nix
  # /common/cpu/intel/cpu-only.nix
  # /common/gpu/intel/default.nix
  #
  # Last reviewed: 2023-12-06

  hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.kernelModules = [ "i915" ];

  boot.kernelParams = [
    "mem_sleep_default=deep"  # Power saving
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
    "i915.enable_guc=3"
    "acpi_osi=\"!Windows 2020\""  # Power saving
    "nvme.noacpi=1"  # Power saving
  ];

  boot.blacklistedKernelModules = [ 
    "hid-sensor-hub"  # Fix to make the brightness and airplane mode keys work
    "cros_ec_lpcs"  # Fixes some crashes during sleep
    "cros-usbpd-charger"  # Causes boot time error log
  ];

  # Additional fix to make the brightness and airplane mode keys work
  systemd.services.bind-keys-driver = {
    description = "Bind brightness and airplane mode keys to their driver";
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script = ''
      echo asdf
      # ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
      # if [ -e /sys/bus/i2c/devices/i2c-FRMW0001:00 -a ! -e /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-FRMW0001:00 ]; then
      #   echo fixing
      #   echo i2c-FRMW0001:00 > /sys/bus/i2c/drivers/i2c_hid_acpi/bind
      #   ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
      #   echo done
      # else
      #   echo no fix needed
      # fi
    '';
  };

  boot.extraModprobeConfig = ''
    # Fix TRRS headphones missing a mic
    options snd-hda-intel model=dell-headset-multi
  '';

  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

    # Fix headphone noise when on power save
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';


  # Mis-detected by nixos-generate-config
  # https://github.com/NixOS/nixpkgs/issues/171093
  # https://wiki.archlinux.org/title/Framework_Laptop#Changing_the_brightness_of_the_monitor_does_not_work
  hardware.acpilight.enable = true;

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  hardware.opengl.extraPackages = [
    pkgs.intel-vaapi-driver
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];
}

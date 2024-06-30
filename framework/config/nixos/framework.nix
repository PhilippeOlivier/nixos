{
  pkgs
, ...
}:

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
  # Last reviewed: 2024-01-02

  boot = {
    blacklistedKernelModules = [ 
      "hid-sensor-hub"      # Fix to make the brightness and airplane mode keys work (also disables ambient light sensor)
      "cros_ec_lpcs"        # Fixes some crashes during sleep
      "cros-usbpd-charger"  # Causes boot time error log
    ];
    extraModprobeConfig = ''
      # Fix TRRS headphones missing a mic
      options snd-hda-intel model=dell-headset-multi
    '';
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "mem_sleep_default=deep"      # Power saving
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.enable_guc=3"
      "acpi_osi=\"!Windows 2020\""  # Power saving
      "nvme.noacpi=1"               # Power saving
      "i915.force_probe=46a6"       # Driver for 12th Gen (Alder Lake): Run `lspci -nn | grep VGA` and replace `46a6` with the 4 characters after `8606:`
    ];
  };

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  hardware = {
    acpilight.enable = true;
    cpu.intel.updateMicrocode = true;
    opengl.enable = true;
    opengl.extraPackages = with pkgs; [
      mesa
      intel-compute-runtime
      libvdpau-va-gl
      intel-media-driver
    ];
  };

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
      # Only apply this fix if it is needed
      if [ -e /sys/bus/i2c/devices/i2c-FRMW0001:00 -a ! -e /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-FRMW0001:00 ]; then
        echo i2c-FRMW0001:00 > /sys/bus/i2c/drivers/i2c_hid_acpi/bind
      fi
    '';
  };

  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

    # Fix headphone noise when on power save
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';
}

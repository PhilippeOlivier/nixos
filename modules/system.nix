{ config, pkgs, ... }:

{
  # Required for sway with HM
  security.polkit.enable = true;

  # Allow updating the firmware
  # Run `fwupdmgr update` to update
  services.fwupd.enable = true;

  # Fingerprint reader
  services.fprintd.enable = true;

  # TRIM
  services.fstrim.enable = true;

  # Detect and manage display brightness
  hardware.sensor.iio.enable = true;

  # ACPI
  boot = {
    kernelModules = [
      "acpi_call"
    ];
    extraModulePackages = [
      config.boot.kernelPackages.acpi_call
    ];
  };

  # Power management
  services.tlp = {
    enable = true;
    settings = {
      TLP_DEFAULT_MODE = "BAT";
      TLP_PERSISTENT_DEFAULT = 1;
      USB_AUTOSUSPEND = 0;
      RUNTIME_PM_ON_AC = "auto";
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # Video
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
}



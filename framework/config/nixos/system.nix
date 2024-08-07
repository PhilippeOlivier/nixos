{
  pkgs
, ...
}:

{
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

  # Video
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      intel-compute-runtime
      libvdpau-va-gl
      intel-media-driver
    ];

    # Required for Steam
    enable32Bit = true;
    extraPackages32 = with pkgs; [
      mesa
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
  
  # Allow updating the firmware
  # Run `fwupdmgr update` to update
  services.fwupd.enable = true;

  # TRIM
  services.fstrim.enable = true;

  # Time
  time.timeZone = "Canada/Eastern";

  # Locale
  i18n.defaultLocale = "en_CA.UTF-8";

  # Fingerprint reader
  services.fprintd.enable = true;

  environment.persistence = {
    "/snap" = {
      directories = [
        "/var/lib/fprint"
      ];

      files = [
        "/etc/machine-id"
      ];
    };

    "/nosnap" = {
      directories = [
        "/var/cache"
        "/var/log"
        "/var/lib/systemd"
      ];
    };
  };
}

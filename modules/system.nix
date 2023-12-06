{ config, pkgs, ... }:

{
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
    };
  };
  



  # ###########3
  # hardware = {
  #   opengl = {
  #     enable = true;
  #     driSupport = true;
  #     extraPackages = [
  #       pkgs.intel-media-driver
  #       pkgs.intel-ocl
  #       pkgs.intel-vaapi-driver
  #       pkgs.mesa
  #       pkgs.intel-compute-runtime
  #       pkgs.libvdpau-va-gl
  #       pkgs.libva-utils
  #     ];
  #   };
  # };



  # from arch:
  # - xdg-desktop-portal-wlr: screen sharing
  # X mesa
  # X vulkan-icd-loader (already included)
  # X vulkan-intel (already included)

  # hardware accel
  # X intel-media-driver   
  # - libva-vdpau-driver ??
  # X libvdpau-va-gl
  # X libva-utils
  
  
  # Driver for 12th Gen (Alder Lake)
  # Run `lspci -nn | grep VGA` and replace `46a6` with the 4 characters after `8606:`
  # boot.kernelParams = [ "i915.force_probe=46a6" ];

  # environment.systemPackages = [
  #   pkgs.mesa
  #   pkgs.intel-ocl
  #   pkgs.
  # ];
  
  # services.throttled.enable = true;  # what is this for?
  
  # hardware.opengl.extraPackages = [
  #   pkgs.intel-compute-runtime  # Intel Gen8 and later GPUs
  #   look into vulkan here: https://nixos.org/manual/nixos/stable/
  #   pkgs.intel-media-driver  # For Intel newer GPUs
  #   etc? see arch
  # ];
}



{ config, pkgs, ... }:

{
  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.intel-ocl
        pkgs.intel-vaapi-driver
        pkgs.mesa
        pkgs.intel-compute-runtime
        pkgs.libvdpau-va-gl
        pkgs.libva-utils
      ];
    };
  };
  
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



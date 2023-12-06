{ config, pkgs, ... }:

{
  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [
        intel-media-driver
      ];
    };
  };
  
  # from arch:
  # - xdg-desktop-portal-wlr: screen sharing
  # - mesa
  # - vulkan-icd-loader
  # - vulkan-intel

  # hardware accel
  # - intel-media-driver   
  # - libva-vdpau-driver
  # - libvdpau-va-gl
  # - libva-utils
  
  
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
  # hardware.opengl.enable = true;
  # hardware.opengl.driSupport = true;
}



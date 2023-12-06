{ config, pkgs, ... }:

{
  ### The following comes from: https://github.com/NixOS/nixos-hardware
  ### Last reviewed: 2023-12-06

  ### /framework/13-inch/12th-gen-intel/README.md
  
  # Allow updating the firmware
  # Run `fwupdmgr update` to update
  services.fwupd.enable = true;

  ### /framework/13-inch/12th-gen-intel/default.nix

  boot.kernelParams = [
    # For Power consumption
    # https://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html
    "mem_sleep_default=deep"
    # Workaround iGPU hangs
    # https://discourse.nixos.org/t/intel-12th-gen-igpu-freezes/21768/4
    "i915.enable_psr=1"
  ];

  boot.blacklistedKernelModules = [ 
    # This enables the brightness and airplane mode keys to work
    # https://community.frame.work/t/12th-gen-not-sending-xf86monbrightnessup-down/20605/11
    "hid-sensor-hub"
    # This fixes controller crashes during sleep
    # https://community.frame.work/t/tracking-fn-key-stops-working-on-popos-after-a-while/21208/32
    "cros_ec_lpcs"
  ];

  # Further tweak to ensure the brightness and airplane mode keys work
  # https://community.frame.work/t/responded-12th-gen-not-sending-xf86monbrightnessup-down/20605/67
  systemd.services.bind-keys-driver = {
    description = "Bind brightness and airplane mode keys to their driver";
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    script = ''
      ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
      if [ -e /sys/bus/i2c/devices/i2c-FRMW0001:00 -a ! -e /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-FRMW0001:00 ]; then
        echo fixing
        echo i2c-FRMW0001:00 > /sys/bus/i2c/drivers/i2c_hid_acpi/bind
        ls -lad /sys/bus/i2c/devices/i2c-*:* /sys/bus/i2c/drivers/i2c_hid_acpi/i2c-*:*
        echo done
      else
        echo no fix needed
      fi
    '';
  };

  # Alder Lake CPUs benefit from kernel 5.18 for ThreadDirector (Philippe: this is not needed as we run unstable which is using kernel 6.*)

  ### /framework/13-inch/common/default.nix

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  #
  # This is temporary until a kernel patch is submitted
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = true;

  ### /framework/13-inch/common/intel.nix

  # temporary commented out because already declared above
  # boot.kernelParams = [
  #   # Fixes a regression in s2idle, making it more power efficient than deep sleep
  #   "acpi_osi=\"!Windows 2020\""
  #   # For Power consumption
  #   # https://community.frame.work/t/linux-battery-life-tuning/6665/156
  #   "nvme.noacpi=1"
  # ];

  # Requires at least 5.16 for working wi-fi and bluetooth. (Philippe: this is not needed as we run unstable which is using kernel 6.*)

  # Module is not used for Framework EC but causes boot time error log.
  boot.blacklistedKernelModules = [ "cros-usbpd-charger" ];

  # Custom udev rules
  services.udev.extraRules = ''
    # Fix headphone noise when on powersave
    # https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';

  # Mis-detected by nixos-generate-config
  # https://github.com/NixOS/nixpkgs/issues/171093
  # https://wiki.archlinux.org/title/Framework_Laptop#Changing_the_brightness_of_the_monitor_does_not_work
  hardware.acpilight.enable = true;

  # This adds a patched ectool, to interact with the Embedded Controller (Philippe: I am not interested)

  ### /common/cpu/intel/cpu-only.nix

  hardware.cpu.intel.updateMicrocode = true;

  ### /common/gpu/intel/default.nix

  boot.initrd.kernelModules = [ "i915" ];

  environment.variables = {
    VDPAU_DRIVER = "va_gl";
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];

  ### /common/pc/laptop/default.nix and acpi_call.nix

  services.tlp.enable = true;

  boot.kernelModules = [
    "acpi_call"
  ];
  
  boot.extraModulePackages = [
    config.boot.kernelPackages.acpi_call
  ];
  
  ### /common/pc/ssd/default.nix

  services.fstrim.enable = true;


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



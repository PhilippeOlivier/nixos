{ config, pkgs, ... }:

{
  # Use the latest kernel compatible with ZFS
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Disable hibernation
  boot.kernelParams = [ "nohibernate" ];

  # ZFS scrub/trim
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    # autoSnapshot = {
    #   enable = true;
    #   frequent = 4;
    #   hourly = 24;
    #   daily = 7;
    #   weekly = 4;
    #   monthly = 12;
    # };
  };

  # Sanoid/Syncoid
  services.sanoid = {
    enable = true;
    interval = "hourly";
    datasets = {
      "tank/home" = {
        autoprune = true;
        autosnap = true;
        hourly = 24;
        daily = 30;
        monthly = 6;
        yearly = 0;
      };
    };
  };
}

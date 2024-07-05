{
  config
, pkgs
, ...
}:

{
  # Use the latest kernel compatible with ZFS
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # Disable hibernation
  boot.kernelParams = [ "nohibernate" ];

  # ZFS scrub/trim
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  # Note: `syncoid` is managed manually by a separate script
  services.sanoid = {
    enable = true;
    interval = "hourly";
    datasets = {
      "tank/snap" = {
        autoprune = true;
        autosnap = true;
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 3;
        yearly = 0;
      };
      "tank/nosnap".autosnap = false;
    };
  };
}

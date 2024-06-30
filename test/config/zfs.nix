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
    interval = "1m"; # <- temp (put "hourly")
    datasets = {
      "tank/snap" = {
        autoprune = true;
        autosnap = true;
        frequently = 4;  # <- temp (remove)
        hourly = 24;
        daily = 7;
        weekly = 4;
        monthly = 3;
        yearly = 0;
      };
      "tank/nosnap".autosnap = false;
    };
  };

  # Required for ZFS backups
  environment.systemPackages = with pkgs; [
    sanoid #temp
    cryptsetup
    lz4
    mbuffer
  ];
}

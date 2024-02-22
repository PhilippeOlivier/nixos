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
  };

  services.sanoid = {
    enable = true;
    interval = "hourly";
    datasets = {
      "tank/home" = {
        autoprune = true;
        autosnap = true;
        hourly = 24;
        daily = 14;
        monthly = 3;
        yearly = 0;
      };
    };
  };

  # Manage syncoid manually to check for hard drives on remote server
  # services.syncoid = {
  #   enable = true;
  #   sshKey = "/home/pholi/.ssh/id_ed25519";
  #   # interval = "hourly";
  # };

  # Required for ZFS backups
  environment.systemPackages = [
    pkgs.cryptsetup
    pkgs.lz4
    pkgs.mbuffer
    pkgs.sanoid
  ];
}

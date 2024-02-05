{ config, pkgs, ... }:

{
  # For my use case, Syncthing secrets can be in the open since no meaningful data is exchanged between devices.

  services.syncthing = {
    enable = true;
    dataDir = "/home/pholi/syncthing";
    configDir = "/home/pholi/.nixos-extra/syncthing";
    openDefaultPorts = true;
    user = "pholi";
    group = "users";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "lineageos" = {
          id = "V5EOWSR-I6QSLAN-2AM3Y4I-VUMXQJS-RUVFSI4-G43O6TM-Q3EMYXB-G5PEZQH";
        };
        "macbook" = {
          id = "RWJ6FMQ-GCFFI7D-MZBBM5T-U6BQAWV-BJFTMP6-FE6DPMB-MRYLCVL-HM6J6AO";
        };
      };
      folders = {
        "Two-Way" = {
          label = "Two-Way";
          id = "xz98j-hf9mm";
          path = "/home/pholi/syncthing/twoway";
          devices = [
            "lineageos"
          ];
          type = "sendreceive";
          rescanIntervalS = 60;
          fsWatcherEnabled = true;
          fsWatcherDelayS = 10;
        };
      };
    };
  };
}

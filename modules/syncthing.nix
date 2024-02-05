{ config, pkgs, ... }:

{
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
        # "device1" = { id = "DEVICE-ID-GOES-HERE"; };
        # "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      };
      folders = {
        "Two-Way" = {
          path = "/home/pholi/syncthing/twoway";
          # devices = [ "device1" "device2" ];
          type = "receiveonly";
          label = "Two-Way label";
          id = "twowayIDID";
        };
      };
    };
  };
}

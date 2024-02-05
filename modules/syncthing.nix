{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/pholi/syncthing";
    configDir = "/home/pholi/testsyncconfig";
    openDefaultPorts = true;
    user = "pholi";
    group = "users";
  };
}

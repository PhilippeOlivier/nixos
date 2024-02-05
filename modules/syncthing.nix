{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/pholi/syncthing";
    openDefaultPorts = true;
    user = "pholi";
    group = "users";
  };
}

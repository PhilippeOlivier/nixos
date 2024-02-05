{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    dataDir = "/home/pholi/syncthing";
  };
}

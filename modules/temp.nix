{ config, pkgs, ... }:

{
  # To allow installation of `imv`
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];
}

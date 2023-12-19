{ config, pkgs, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/fonts.nix
    ./modules/framework.nix
    ./modules/network.nix
    ./modules/python.nix
    ./modules/system.nix
    ./modules/users.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
}


{ config, pkgs, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/fonts.nix
    ./modules/framework.nix
    ./modules/network.nix
    ./modules/system.nix
    ./modules/time-locale.nix
    ./modules/users.nix
    ./hardware-configuration.nix
  ];

  security.polkit.enable = true;  # Required for sway with HM

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
}


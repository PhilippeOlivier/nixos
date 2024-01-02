{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/fonts.nix
    ./modules/framework.nix
    ./modules/network.nix
    ./modules/python.nix
    ./modules/system.nix
    ./modules/users.nix
  ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # TEMP: WiFi
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
}


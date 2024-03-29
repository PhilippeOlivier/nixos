{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/crypto.nix
    ./modules/fonts.nix
    ./modules/framework.nix
    ./modules/network.nix
    ./modules/printers.nix
    ./modules/services.nix
    ./modules/syncthing.nix
    ./modules/system.nix
    ./modules/thunar.nix
    ./modules/users.nix
    ./modules/zfs.nix
    ./modules/temp.nix
  ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # TEMP: WiFi
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
}


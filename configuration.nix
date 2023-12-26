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
    # ./secrets/wifi-networks.nix
  ];

  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  imports = [ <sops-nix/modules/sops> ];
  
  sops.defaultSopsFile = ./secrets/test.yaml;
  # # YAML is the default 
  sops.defaultSopsFormat = "yaml";

  # sops.secrets."ssh_key".mode = "0400";
  # sops.secrets.ssh_key = {
  #   format = "yaml";
  #   # can be also set per secret
  #   sopsFile = ./secrets/test.yaml;
  # };
}


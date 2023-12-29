{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ## SYSTEM
  
  system.stateVersion = "24.05";
  boot.loader.systemd-boot.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # USERS
  
  users.mutableUsers = false;
  
  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3";
  };
  
  users.users.pholi = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3";
    description = "Philippe Olivier";
    home = "/home/pholi";
    extraGroups = [
      "docker"
      "wheel"
    ];
  };

  # NETWORK
  
  networking = {
    hostName = "pholi-nixos";

    # Use wpa_supplicant
    wireless.enable = true;

    # DHCP (set to false because it is deprecated)
    useDHCP = false;

    # We must set all interfaces individually
    interfaces.wlp4s0.useDHCP = true;
    interfaces.enp0s31f6.useDHCP = true;
  };
  
  # WiFi networks
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";

  # SOPS
  
  # sops.defaultSopsFile = ./secrets/secrets.yaml;
  # # # YAML is the default 
  # sops.defaultSopsFormat = "yaml";
  # # sops.age.keyFile = "/home/pholi/.config/sops/age/keyz.txt";

  # sops.secrets."ssh_key".mode = "0400";
  # sops.secrets.ssh_key = {
  #   format = "yaml";
  #   # can be also set per secret
  #   sopsFile = ./secrets/test.yaml;
  # };
}


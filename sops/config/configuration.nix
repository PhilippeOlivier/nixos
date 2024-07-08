{
  lib
, pkgs
, stateVersion
, hostName
, homeDirectory
, username
, wirelessDevice
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
    ./zfs.nix
  ];

  sops = {
    age.keyFile = "/home/pholi/nixos/test/extra/sops/age-key.txt";
  };
  
  environment.systemPackages = [
    pkgs.git
    pkgs.tree
  ];
  
  system.stateVersion = stateVersion;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # BOOT
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  # NETWORK
  networking = {
    hostName = hostName;

    # Use wpa_supplicant
    wireless = {
      enable = true;
      networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
    };

    # Network interfaces
    interfaces = {
      ${wirelessDevice} = {
        useDHCP = true;
      };
    };

    # systemd-resolved
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  };
  services = {
    # systemd-resolved
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };

  # USERS
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$G0Y8DMYeCovADHuKDb73a1$KqGTktIZlpdjEH4yubPnVTpZywk2Zf6fbk979YvKPk3";
  };
  
  users.users.${username} = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$/agu8wY6h/PB20gbxj6aC.$JEuBPcl7F5crecpUFQ3SH.cEsNjMYD.8JnHArimSAt/";
    description = "Philippe Olivier";
    home = homeDirectory;
    shell = pkgs.bash;
    extraGroups = [
      "adbusers"
      "docker"
      "wheel"
    ];
  };

  # Auto-login (this is okay since the disk has to be decrypted manually beforehand)
  services.getty.autologinUser = username;

  # This is required to run many scripts correctly
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

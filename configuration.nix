{ config, pkgs, ... }:

# let
#   home-manager = builtins.fetchTarball {
#     url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
#   };
  
#in
{
  imports =
    [
      ./modules/boot.nix
      ./modules/time-locale.nix
      ./modules/network.nix
      ./hardware-configuration.nix
      # "${home-manager}/nixos"
    ];

  # Users
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3"; # asdf
    # hashedPassword = "$y$j9T$G0Y8DMYeCovADHuKDb73a1$KqGTktIZlpdjEH4yubPnVTpZywk2Zf6fbk979YvKPk3";
  };

  # # Home manager configuration for user jane.
  # home-manager.users.pholi = { pkgs, ... }: {
  #   programs.home-manager.enable = true;
  #   home.stateVersion = "23.05";
  # };
  
  users.users.pholi = {
    isNormalUser = true;
    home = "/home/pholi";
    hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3"; # asdf
    # hashedPassword = "$y$j9T$/agu8wY6h/PB20gbxj6aC.$JEuBPcl7F5crecpUFQ3SH.cEsNjMYD.8JnHArimSAt/";
    description = "Philippe Olivier";
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      # Desktop environment
      alacritty
      sway

      # Misc
      git
      emacs
      firefox
    ];
  };

  programs.sway = {
    enable = true;
    # wrapperFeatures.gtk = true;
  };
  # environment.systemPackages = with pkgs; [
  #   pkgs.powertop
  #   pkgs.acpi
  #   pkgs.upower
  # ];
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}


{ config, pkgs, ... }:

{
  imports = [
    ./home/emacs.nix
    ./home/git.nix
    ./home/shell.nix
    # ./home/secrets.nix
    ./home/sway.nix
    ./home/thunar.nix
    ./home/transmission.nix
    ./home/xdg.nix
    ./home/zathura.nix
  ];

  home = {
    stateVersion = "24.05";
    username = "pholi";
    homeDirectory = "/home/pholi";
    packages = with pkgs; [
      # Audio
      bluez
      pipewire
      wireplumber

      # Programs
      imv
      # libreoffice

      # Utilities
      docker-compose
      htop

      # WiFi tools
      # aircrack-ng
      # hashcat
      # hashcat-utils
      # macchanger
      # reaverwps

      pinentry-curses

      # Python
      (python311.withPackages(ps: with ps; [
        # General
        pip

        # Science
        matplotlib
        networkx
        numpy
        pandas
        scipy

        # Optimization
        ortools

        # Misc
        grip
      ]))
    ];
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "emacs";
      MOZ_ENABLE_WAYLAND = "1";  # Run Firefox in Wayland mode
      VISUAL = "emacs";
    };
    shellAliases = {
      grip = ''grip --pass $(pass show github.com/token)'';  # Use my GitHub token to avoid the hourly rate limit
      ls = "ls --color=auto";  # Colorize the `ls` command
      opto = "python ~/scripts/emma/opto/opto.py";  # Run the wife's opto script
      reboot = "emacsclient -e '(save-some-buffers t)' && reboot";  # Save all Emacs buffers before rebooting
    };
  };

  programs.home-manager.enable = true;
}

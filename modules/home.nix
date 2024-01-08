{ config, pkgs, ... }:

{
  imports = [
    ./home/chromium.nix
    ./home/crypto.nix
    ./home/emacs.nix
    ./home/git.nix
    ./home/latex.nix
    ./home/pdf.nix
    ./home/python.nix
    ./home/shell.nix
    ./home/sway.nix
    ./home/thunar.nix
    ./home/transmission.nix
    ./home/xdg.nix
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
      inkscape
      libreoffice

      # Utilities
      docker-compose
      htop

      # WiFi tools
      # aircrack-ng
      # hashcat
      # hashcat-utils
      # macchanger
      # reaverwps
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

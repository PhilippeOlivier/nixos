{ config, pkgs, ... }:

{
  imports = [
    ./home/browsers.nix
    ./home/crypto.nix
    ./home/emacs.nix
    ./home/git.nix
    ./home/latex.nix
    ./home/mail.nix
    ./home/mpv.nix
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

      # Communication
      discord
      signal-desktop

      # Console
      busybox
      curl
      expect
      fzf
      imagemagick
      jq
      pdfgrep
      tmux
      udisks
      vim
      ydotool
      yt-dlp

      # Filesystem
      exfat
      exfatprogs
      hfsprogs
      ntfs3g
      parted

      # Games
      lutris
      steam   # necessary?

      # Programs
      imv
      inkscape
      libreoffice

      # Utilities
      docker-compose
      htop
      macchanger
    ];
    # Prevent Discord from checking for new versions by itself
    file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
    '';
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
      # reboot = "emacsclient -e '(save-some-buffers t)' && reboot";  # Save all Emacs buffers before rebooting
    };
  };

  programs.home-manager.enable = true;
}

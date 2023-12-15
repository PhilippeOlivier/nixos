{ config, pkgs, ... }:

{
  imports = [
    ./home/emacs.nix
    ./home/git.nix
    ./home/shell.nix
    ./home/sway.nix
  ];
  
  home = {
    stateVersion = "24.05";
    username = "pholi";
    homeDirectory = "/home/pholi";
    packages = with pkgs; [
      brightnessctl
      htop

      # Sway-specific
      libnotify
      swayidle
      swaylock

      # Waybar-specific
      acpi
      bc
      gsimplecal
      jq
      wget

      # Audio
      bluez
      pipewire
      wireplumber
    ];
    sessionVariables = {
      BROWSER = "firefox";  # TODO: abs path?
      EDITOR = "emacs";  # TODO: abs path?
      MOZ_ENABLE_WAYLAND = "1";  # Run Firefox in Wayland mode
      PS1 = ''[\u@\h \W]\$ '';
      VISUAL = "emacs";  # TODO: abs path?
    };
    shellAliases = {
      grip = ''grip --pass $(pass show github.com/token)'';  # Use my GitHub token to avoid the hourly rate limit
      ls = "ls --color=auto";  # Colorize the `ls` command
      opto = "python ~/scripts/emma/opto/opto.py";  # Run the wife's opto script
      reboot = "emacsclient -e '(save-some-buffers t)' && reboot";  # Save all Emacs buffers before rebooting
    };
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
#   home.packages = with pkgs; [
#     # here is some command line tools I use frequently
#     # feel free to add your own or remove some of them

#     neofetch
#     #alacritty
#     #sway
    
#     # Misc
# #    git
#     #firefox

#   ];

  programs.home-manager.enable = true;
}

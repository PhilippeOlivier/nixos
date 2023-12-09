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
      neofetch
    ];
    sessionVariables = {
      EDITOR = "emacs";
      ASDF = "asdf";
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
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    #alacritty
    #sway
    
    # Misc
#    git
    #firefox

  ];

  programs.home-manager.enable = true;
}

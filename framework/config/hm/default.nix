{
  pkgs # todo: remove
, stateVersion
, homeDirectory
, username
, ...
}:

let
  #functest = import ./func.nix;
  #functest = pkgs.callPackage ./func.nix;
  myFunction = import ./func.nix;
in

{
  imports = [
    ./de

    ./chromium.nix
    ./emacs.nix
    ./git.nix
    ./latex.nix
    ./mpv.nix
    ./thunar.nix
  ];

  myFunction { a = "hello"; };
  
  home = {
    stateVersion = stateVersion;
    username = username;
    homeDirectory = homeDirectory;
  };

  programs.home-manager.enable = true;

  home.persistence."/snap/home/${username}" = {
    allowOther = true;

    directories = [
      "nixos"  # all main personal directories here
    ];

    files = [
      ".bash_history"  # TODO: put somewhere else
    ];
  };
  
  xdg = {
    enable = true;
    cacheHome = "/home/pholi/.cache";
    configHome = "/home/pholi/.config";
    dataHome = "/home/pholi/.local/share";
    # desktopEntries.alacrittyTEST = {
    #   name = "alacritty TEST";
    #   genericName = "alacritty TEST";
    #   exec = "alacritty";
    #   settings = {
    #     TryExec = "alacritty";
    #   };
    # };
    dataFile."/home/pholi/.config/desktop-test/applications/alacritty.desktop".text = ''
[Desktop Entry]
Name=alacritty
Type=Application
Exec=alacritty
    '';
  };
}

{
  homeDirectory
, stateVersion
, username
, desktopEntriesDirectory # todo: temp
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix;
in

{
  imports = [
    ./de

    ./chromium.nix
    ./discord.nix
    ./emacs.nix
    ./git.nix
    ./inkscape.nix
    ./latex.nix
    ./libreoffice.nix
    ./mpv.nix
    ./signal.nix
    ./slack.nix
    ./thunar.nix
    ./xournalpp.nix
  ];
  
  home = {
    stateVersion = stateVersion;
    username = username;
    homeDirectory = homeDirectory;
  };

  programs.home-manager.enable = true;

  home.persistence = {
    "/snap/home/${username}" = {
      allowOther = true;

      directories = [
        "nixos"  # all main personal directories here
      ];

      files = [
        ".bash_history"  # TODO: put somewhere else
      ];
    };
    "/nosnap/home/${username}" = {
      allowOther = true;
    };
  };
  
  xdg = {
    enable = true;
    dataFile = desktopEntry {
      name = "alacriTTY";
      exec = "alacritty"
    };
    cacheHome = "/home/pholi/.cache";
    configHome = "/home/pholi/.config";
    #dataHome = "/home/pholi/.config/pholi-desktop-entries"; #"/home/pholi/.local/share";
    # desktopEntries.alacrittyTEST = {
    #   name = "alacritty TEST";
    #   genericName = "alacritty TEST";
    #   exec = "alacritty";
    #   settings = {
    #     TryExec = "alacritty";
    #   };
    # };
    #     dataFile."/home/pholi/.config/desktop-test/applications/alacritty.desktop".text = ''
    # [Desktop Entry]
    # Name=alacritty
    # Type=Application
    # Exec=alacritty
    #     '';
  };
}

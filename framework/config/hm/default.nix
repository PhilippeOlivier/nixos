{
  stateVersion
, homeDirectory
, username
, ...
}:

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

  xdg.desktopEntries.alacritty = {
    name = "alacritty TEST";
    genericName = "alacritty TEST";
    exec = "alacritty";
    settings = {
      TryExec = "alacritty";
    };
  };
}

{
  homeDirectory
, stateVersion
, username
, ...
}:

{
  imports = [
    ./de

    ./blueman.nix
    ./chromium.nix
    ./discord.nix
    ./emacs.nix
    ./firefox.nix
    ./git.nix
    #./imv.nix
    ./inkscape.nix
    ./latex.nix
    ./libreoffice.nix
    ./mpv.nix
    ./python.nix
    ./shell.nix
    ./signal.nix
    ./slack.nix
    ./transmission.nix
    ./thunar.nix
    ./xdg.nix
    ./xournalpp.nix
    ./zathura.nix
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
}

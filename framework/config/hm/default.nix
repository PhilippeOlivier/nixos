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
    ./thunar.nix
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
        "nixos"
      ];

      files = [
        ".bash_history"  # TODO: put somewhere else
      ];
    };
  };
}

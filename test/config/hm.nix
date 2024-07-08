{
  pkgs
, stateVersion
, homeDirectory
, username
, ...
}:

{
  home = {
    stateVersion = stateVersion;
    username = username;
    homeDirectory = homeDirectory;
  };

  programs.home-manager.enable = true;

  home.persistence = {
    "/snap/home/pholi" = {
      allowOther = true;

      directories = [
        "nixos"
      ];

      files = [
        ".bash_history"
      ];
    };
  };

  home.packages = with pkgs; [
    sops
  ];
}

{
  config
, pkgs
, desktopEntriesDirectory
, extraDirectory
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
    client = {
      enable = true;
      arguments = [
        "-c"
      ];
    };
  };

  xdg.dataFile = desktopEntry {
    name = "Emacs";
    exec = "emacsclient -c";
  };
  
  home = {
    packages = with pkgs; [
      source-code-pro  # Font for Emacs
    ];

    file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${extraDirectory}/emacs";
  };
}

{
  pkgs
, desktopEntriesDirectory
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

    persistence."/snap/home/${username}" = {
      directories = [
        ".emacs.d"
      ];
    };
  };
}

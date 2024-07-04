{
  pkgs
, desktopEntriesDirectory
, username
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  xdg.dataFile = desktopEntry {
    name = "Signal";
    exec = "signal-desktop";
  };
  
  home = {
    packages = with pkgs; [
      signal-desktop
    ];
    
    persistence."/snap/home/${username}" = {
      directories = [
        ".config/Signal"
      ];
    };
  };
}

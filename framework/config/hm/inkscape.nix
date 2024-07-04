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
    name = "Inkscape";
    exec = "inkscape";
  };
  
  home = {
    packages = with pkgs; [
      inkscape
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/inkscape"
      ];
      files = [
        ".cache/inkscape-clipboard-import"
      ];
    };
  };
}

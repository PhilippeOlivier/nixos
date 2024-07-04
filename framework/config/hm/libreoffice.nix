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
    name = "LibreOffice";
    exec = "libreoffice";
  };
  
  home = {
    packages = with pkgs; [
      libreoffice
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}

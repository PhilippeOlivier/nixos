{
  pkgs
, desktopEntriesDirectory
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  xdg.dataFile = desktopEntry {
    name = "WPA_GUI";
    exec = "wpa_gui";
  };
  
  home = {
    packages = with pkgs; [
      wpa_supplicant_gui
    ];
  };
}

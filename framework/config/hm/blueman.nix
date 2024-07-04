{
  desktopEntriesDirectory
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  # Impermanence: All bluetooth persistence is handled by `bluetooth.nix`.
  
  home = {
    packages = with pkgs; [
      blueman
    ];
  };

  xdg.dataFile = desktopEntry {
    name = "Blueman";
    exec = "blueman-manager";
  };
}

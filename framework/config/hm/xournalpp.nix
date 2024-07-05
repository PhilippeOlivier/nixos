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
    name = "Xournal++";
    exec = "xournalpp";
  };
  
  home = {
    packages = with pkgs; [
      gnome.adwaita-icon-theme  # `xournalpp` will crash without this
      xournalpp
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".cache/xournalpp"
        ".config/xournalpp"
      ];
    };
  };
}

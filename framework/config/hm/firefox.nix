{
  desktopEntriesDirectory
, username
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  programs.firefox.enable = true;

  xdg.dataFile = desktopEntry {
    name = "Firefox";
    exec = "MOZ_ENABLE_WAYLAND=1 firefox";
  };
  
  home = {
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          ".mozilla"
        ];
      };
      
      "/nosnap/home/${username}" = {
        directories = [
          ".cache/mozilla"
        ];
      };
    };
  };
}

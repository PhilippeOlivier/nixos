{
  config
, desktopEntriesDirectory
, extraDirectory
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
    file.".mozilla".source = config.lib.file.mkOutOfStoreSymlink "${extraDirectory}/mozilla";
    persistence = {
      "/nosnap/home/${username}" = {
        directories = [
          ".cache/mozilla"
        ];
      };
    };
  };
}

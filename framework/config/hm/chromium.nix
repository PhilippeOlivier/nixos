{
  desktopEntriesDirectory
, username
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  programs.chromium = {
    enable = true;
    extensions = [
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";  # uBlock Origin
      }
    ];
  };

  xdg.dataFile = desktopEntry {
    name = "Chromium";
    exec = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
  
  home.persistence."/snap/home/${username}" = {
    directories = [
      ".cache/chromium"
      ".config/chromium"
    ];
  };
}

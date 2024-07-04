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
    name = "Slack";
    exec = "slack";
  };
  
  home = {
    packages = with pkgs; [
      slack
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/Slack"
      ];
    };
  };
}

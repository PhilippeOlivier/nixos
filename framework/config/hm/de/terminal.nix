{
  config
, desktopEntriesDirectory
, ...
}:

let
  desktopEntry = import ../desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        size = 20.0;
      };
    };
  };

  xdg.dataFile = desktopEntry {
    name = "Alacritty";
    exec = "alacritty";
  };
  
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+Return" = "exec alacritty";
}

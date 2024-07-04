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

  # xdg.dataFile = desktopEntry {
  #   name = "Alacritty";
  #   exec = "alacritty";
  # };

  xdg.dataFile = desktopEntry {
    entries = [
      { name = "Alacritty"; exec = "alacritty"; }
      { name = "AnotherApp"; exec = "anotherapp"; }
    ];
  };
  
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+Return" = "exec alacritty";
}

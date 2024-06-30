{
  config
, ...
}:

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

  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+Return" = "exec alacritty";
}

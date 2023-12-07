{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      window = {
        titlebar = false;
      };
      terminal = "alacritty";
      modifier = "Mod4";
    };
  };

  programs.alacritty = {
    enable = true;
  };
}

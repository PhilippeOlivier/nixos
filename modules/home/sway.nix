{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      window = {
        titlebar = false;
        terminal = "alacritty";
      };
    };
    # config = rec {
    #   modifier = "Mod4";
    #   # Use kitty as default terminal
    #   terminal = "kitty"; 
    #   startup = [
    #     # Launch Firefox on start
    #     {command = "firefox";}
    #   ];
    # };
  };

  programs.alacritty = {
    enable = true;
  };
}

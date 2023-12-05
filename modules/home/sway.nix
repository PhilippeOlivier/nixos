{
  wayland.windowManager.sway = {
    enable = true;

    config = {
      window = {
        default_border = "pixel";
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
}

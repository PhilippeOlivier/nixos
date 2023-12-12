{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    config = rec {
      window = {
        titlebar = false;  # Hide window title bars
      };
      terminal = "alacritty";
      modifier = "Mod4";  # The modifier key is the Super/Windows key
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+q" = "kill";  # Kill focused window
        "${modifier}+Shift+c" = "reload";  # Reload configuration file
        "${modifier}+Shift+e" = "exec swaymsg exit";  # Exit sway
        "${modifier}+f" = "fullscreen";  # Make the current focus fullscreen
        "${modifier}+r" = "mode resize";  # Resize window

        # Change focus in workspace
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";

        # Move focused window in workspace
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        # Switch to workspace
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        # Move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        # Move workspaces between monitors
        "${modifier}+Control+Shift+Left" = "move workspace to output left";
        "${modifier}+Control+Shift+Right" = "move workspace to output right";

        # script test (set env variable for the rtmin signal)
        # "XF86AudioLowerVolume" = "";
      };
      modes.resize = {
        Escape = "mode default";
        Return = "mode default";
        "${modifier}+r" = "mode default";
        Left = "resize shrink width 10 px or 5 ppt";
        Right = "resize grow width 10 px or 5 ppt";
        Up = "resize shrink height 10 px or 5 ppt";
        Down = "resize grow height 10 px or 5 ppt";
      };
      bars = [];
      startup = [
        {
          command = "waybar";
        }
      ];
    };
  };

  # Status bar
  programs.waybar = {
    enable = true;
    style =''
      * {
          border: none;
          font-family: "Hack";
          font-size: 20px;
      	margin: 1px 0px -1px 0px;
      	/* color: #FFFFFF; */
      }
      
      #waybar {
          background: #000000;
          color: #FFFFFF;
      }
      
      #workspaces button {
          padding: 2px 5px;
          background: black;
          color: white;
          border-bottom: 3px solid transparent;
      }
      
      #workspaces button:hover {
      	color: #000000;
          background: #DCDCDC;
      	text-shadow: none;
      	box-shadow: none;
      }
      
      #workspaces button.focused {
      	color: #000000;
          background: #DCDCDC;
      }
      
      #battery.warning, #pulseaudio.warning {
          background: #FFFF00;
          color: #000000;
      }
      
      #battery.critical, #pulseaudio.critical {
          background: #FF0000;
          color: #000000;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        spacing = 8;
        # height = 30;
        # output = [
        #   "eDP-1"
        #   "HDMI-A-1"
        # ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-right = [
          "custom/clock"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          # all-outputs = true;
        };

        "custom/clock" = {
          exec = pkgs.writeShellScript "custom-clock" ''
            date +'%a %-d %b %-H:%M'
          '';
	        "on-click": "gsimplecal",
    	    interval = 5;
        };
      #   "custom/hello-from-waybar" = {
      #     format = "hello {}";
      #     max-length = 40;
      #     interval = "once";
      #     exec = pkgs.writeShellScript "hello-from-waybar" ''
      #   echo "from within waybar"
      # '';
      #   };
        "custom/test" = {
          format = "ASDF {}";
          interval = "once";
          exec = "$HOME/nixos/modules/home/test.sh";
        };
      };
    };
  };

  # Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      font = {
        size = 20.0;
      };
    };
  };

  # Desktop notifications
  services.mako = {
    enable = true;
  };
}

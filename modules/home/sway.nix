{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      # TrackPad configuration (the command `swaymsg -t get_inputs` will list the names of the inputs)
      input "2:7:SynPS/2_Synaptics_TouchPad" {
        tap enabled
        natural_scroll disabled
        dwt enabled
        accel_profile "flat"
        pointer_accel 0.5
        scroll_method two_finger
      }

      # Position gsimplecal in the bottom right corner
      for_window [app_id="gsimplecal"] move position 2034 1272

      # If any program is full screen, do not suspend
      # Source: https://stackoverflow.com/a/68787102/1725856
      for_window [class=".*"] inhibit_idle fullscreen
      for_window [app_id=".*"] inhibit_idle fullscreen
    '';
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
        "${modifier}+l" = "exec swaylock -Ffkl -c 000000"; # Lock manually
        "XF86MonBrightnessUp" = "exec brightnessctl set +5% && pkill -RTMIN+11 waybar";  # Brightness up
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%- && pkill -RTMIN+11 waybar";  # Brightness down
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+";  # Volume up
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";  # Volume down
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";  # Mute/unmute volume

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
      
      #battery.warning, #wireplumber.warning {
          background: #FFFF00;
          color: #000000;
      }
      
      #battery.critical, #wireplumber.critical {
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
          "custom/brightness"
          "custom/separator"
          "wireplumber"
          "custom/separator"
          "custom/clock"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          # all-outputs = true;
        };

        "custom/brightness" = {
          exec = pkgs.writeShellScript "custom-brightness" ''
            BR="$(brightnessctl | head -n 2 | tail -n 1 | cut -d ' ' -f 4 | tr -d '()')" && \
            echo "Br $BR" && \
            notify-send -h string:x-canonical-private-synchronous:anything -t 500 "''${BRIGHTNESS}" "<span color='#FFFFFF' font='50px'><b>$BR</b></span>"
          '';
    	    interval = "once";
          tooltip = false;
          signal = 11;
        };

        "custom/clock" = {
          exec = pkgs.writeShellScript "custom-clock" ''
            date +'%a %-d %b %-H:%M'
          '';
	        on-click = "gsimplecal";
    	    interval = 5;
          tooltip = false;
        };

        "custom/separator" = {
          exec = pkgs.writeShellScript "custom-separator" ''
            echo "|"
          '';
    	    interval = "once";
          tooltip = false;
        };

        "wireplumber" = {
          format = "Vol {volume}%";
		      format-muted = "Vol {volume}% (M)";
          max-volume = 200.0;
          scroll-step = 0;
		      tooltip = false;
          states = {
            warning = 101;
            critical = 151;
		      };
        };

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

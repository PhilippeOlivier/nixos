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

      # Keyboard layout (the command `swaymsg -t get_inputs` will list the names of the inputs)
      input "1:1:AT_Translated_Set_2_keyboard" {
          xkb_layout us,ca
          xkb_variant ,multix
          xkb_options grp:lalt_lshift_toggle
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
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+ && pkill -RTMIN+13 waybar";  # Volume up
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && pkill -RTMIN+13 waybar";  # Volume down
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && pkill -RTMIN+13 waybar";  # Mute/unmute volume

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
          "custom/mail"
          "custom/separator"
          "custom/network"
          "custom/separator"
          "custom/battery"
          "custom/battery-daemon"
          "custom/separator"
          "custom/keyboard"
          "custom/keyboard-daemon"
          "custom/separator"
          "custom/storage"
          "custom/separator"
          "custom/brightness"
          "custom/separator"
          "custom/volume"
          "custom/separator"
          "custom/clock"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          # all-outputs = true;
        };

        "custom/battery" = {
          exec = pkgs.writeShellScript "custom-battery" ''
            BATTERY="BAT1"

            # If the battery does not exist, show an error.
            if [[ ! -d /sys/class/power_supply/$BATTERY ]]; then
                echo "<span background=\"#FFFF00\" foreground=\"#000000\">$BATTERY ERROR</span>"

            # Otherwise, show the battery information
            else
                PERCENTAGE="$(acpi -b | cut -d ',' -f 2 | tr -d '[:blank:]')"
                PERCENTAGE_INT="$(echo $PERCENTAGE | tr -d '%')"

                # Show a desktop notification when the battery is low.
                if [[ $PERCENTAGE_INT -le 10 ]]; then
                    notify-send -h string:x-canonical-private-synchronous:anything -t 0 "BATTERY" "<span color='#FF0000' font='40px'><b>LOW BATTERY</b></span>"
                fi

                STATUS="$(acpi -b | cut -d ',' -f 1 | cut -d ':' -f 2 | tr -d ' ')"

                REMAINING="$(acpi -b | cut -d ',' -f 3 | cut -d ' ' -f 2)"
                REMAINING="$(date -d $REMAINING '+%-H:%M' 2> /dev/null)"  # Format the time

                # Format the status
                if [[ $STATUS = "Not charging" ]]; then
                    STATUS="AC"
                elif [[ $STATUS = "Discharging" ]]; then
                    STATUS="Di"
                elif [[ $STATUS = "Charging" ]]; then
                    STATUS="Ch"
                fi

                OUTPUT="$PERCENTAGE $STATUS ($REMAINING)"

                # Colorize the output
                if [[ $PERCENTAGE_INT -le 10 ]]; then
                    OUTPUT="<span background=\"#FF0000\" foreground=\"#000000\">$OUTPUT</span>"
                elif [[ $PERCENTAGE_INT -le 15 ]]; then
                    OUTPUT="<span background=\"#FFFF00\" foreground=\"#000000\">$OUTPUT</span>"
                fi

                echo "$OUTPUT"
            fi
          '';
    	    interval = "once";
          tooltip = false;
          signal = 12;
        };

        "custom/battery-daemon" = {
          exec = pkgs.writeShellScript "custom-battery-daemon" ''
            # This daemon triggers updates for the `custom/battery` module.

            BATTERY="BAT1"

            # If the battery does not exist, exit
            if [[ ! -d /sys/class/power_supply/$BATTERY ]]; then
                exit
            fi

            # An update is triggered when:
            #   1. The battery status changes (`inotifywait`).
            #   2. The last update was 30 seconds ago (--timeout 25 + sleep 5).
            # An update cannot be triggered more than once every 5 seconds (sleep 5).
            while true; do
                # Monitor the status of the battery.
                if ! inotifywait --quiet --timeout 25 --event access /sys/class/power_supply/$BATTERY/status &> /dev/null; then
                    sleep 5
                fi
                pkill -RTMIN+12 waybar
            done
          '';
    	    interval = "once";
          tooltip = false;
        };

        "custom/brightness" = {
          exec = pkgs.writeShellScript "custom-brightness" ''
            BR="$(brightnessctl | head -n 2 | tail -n 1 | cut -d ' ' -f 4 | tr -d '()')" && \
            echo "Br $BR" && \
            notify-send -h string:x-canonical-private-synchronous:anything -t 500 "\$\{BRIGHTNESS^^\}" "<span color='#FFFFFF' font='50px'><b>$BR</b></span>"
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

        "custom/keyboard" = {
          exec = pkgs.writeShellScript "custom-keyboard" ''
            CAPS_LOCK=$(cat "/sys/class/leds/input1::capslock/brightness")

            if swaymsg -pt get_inputs | grep -q "Canadian (CSA)"; then
                LAYOUT="FR"
            else
                LAYOUT="EN"
            fi

            if [[ $CAPS_LOCK -eq 1 ]]; then
                echo "<span background=\"#FFFFFF\" foreground=\"#000000\">$LAYOUT</span>"
            else
                echo "$LAYOUT"
            fi
          '';
    	    interval = "once";
          tooltip = false;
          signal = 14;
        };

        "custom/keyboard-daemon" = {
          exec = pkgs.writeShellScript "custom-keyboard-daemon" ''
            # This daemon triggers updates for the `custom/keyboard` module.
            # An update is triggered when the keyboard layout changes or when the caps lock key is pressed.
            while true; do
                if ! inotifywait --quiet --event access /sys/class/leds/input1::capslock/brightness &> /dev/null; then
                    pkill -RTMIN+14 waybar
                    echo ASDF
                fi
            done
          '';
    	    interval = "once";
          tooltip = false;
        };

        "custom/mail" = {
          exec = pkgs.writeShellScript "custom-mail" ''
            echo mail
          '';
    	    interval = 30;
          tooltip = false;
        };

        "custom/network" = {
          exec = pkgs.writeShellScript "custom-network" ''
            echo network
          '';
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

        "custom/storage" = {
          exec = pkgs.writeShellScript "custom-storage" ''
            echo storage
          '';
    	    interval = 30;
          tooltip = false;
        };

        "custom/volume" = {
          exec = pkgs.writeShellScript "custom-volume" ''
            VOLUME="$(echo "100 * $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2)" | bc | cut -d '.' -f 1)"

            MUTE=""
            if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
            	MUTE=" (M)"
            fi

            OUTPUT="$VOLUME$MUTE"

            FG="#FFFFFF"
            BG="#000000"
            NOTIFIER="#FFFFFF"
            if [[ $VOLUME -gt 150 ]]; then
                FG="#000000"
                BG="#FF0000"
                NOTIFIER="#FF0000"
            elif [[ $VOLUME -gt 100 ]]; then
                FG="#000000"
                BG="#FFFF00"
                NOTIFIER="#FF0000"
            fi

            echo "<span background=\"$BG\" foreground=\"$FG\">Vol $OUTPUT</span>"

            notify-send -h string:x-canonical-private-synchronous:anything -t 500 "VOLUME" "<span color=\"$NOTIFIER\" font='50px'><b>$OUTPUT</b></span>"
          '';
    	    interval = "once";
          tooltip = false;
          signal=13;
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

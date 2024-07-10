{
  pkgs
, config #TODO TEMP
, outputHeight
, outputWidth
, signalBattery
, signalBrightness
, signalKeyboard
, signalMail
, signalNetwork
, signalVolume
, wirelessDevice
, ...
}:

let

  gsimplecalX = builtins.toString (builtins.fromJSON outputWidth - 245);

  gsimplecalY = builtins.toString (builtins.fromJSON outputHeight - 221);
  
  batteryScript = pkgs.writeShellScript "waybar-battery.sh" ''
    for item in $(${pkgs.upower}/bin/upower --dump | ${pkgs.jc}/bin/jc --upower | tr ' ' '_' | ${pkgs.jq}/bin/jq -c '.[]'); do  # `tr` because issue with spaces in the date
        if [[ $(echo $item | ${pkgs.jq}/bin/jq '.native_path') =~ \"BAT[0-9]\" ]]; then
            STATE=$(echo $item | ${pkgs.jq}/bin/jq '.detail.state' | tr -d '"')
            TIME=$(echo $item | ${pkgs.jq}/bin/jq '.detail.time_to_empty')
            PERCENTAGE=$(echo "($(echo "$item" | ${pkgs.jq}/bin/jq '.detail.percentage')+0.5)/1" | ${pkgs.bc}/bin/bc)
        elif [[ $(echo $item | ${pkgs.jq}/bin/jq '.native_path') = "\"ACAD\"" ]]; then
            AC=$(echo $item | ${pkgs.jq}/bin/jq '.detail.online')
        fi
    done

    # In case we don't have the time information
    if [[ $TIME = "null" ]]; then
        TIME="-"
    fi

    if [[ $AC = "true" && $PERCENTAGE -ge 95 ]]; then
        # If the AC is plugged in and that the percentage is high enough, just report
        # that the battery is fully charged, no matter what the real state says
        # (because `upower` doesn't seem to be reporting states correctly)
        STATE="fully-charged"
    fi

    # Construct the output
    if [[ $STATE = "fully-charged" ]]; then
        OUTPUT="$PERCENTAGE% AC"
    elif [[ $STATE = "charging" ]]; then
        OUTPUT="$PERCENTAGE% Ch ($TIME)"
    elif [[ $STATE = "discharging" ]]; then
        OUTPUT="$PERCENTAGE% Di ($TIME)"
    else
        OUTPUT="-% Uk (-)"
    fi

    # Colorize the output
    if [[ $PERCENTAGE -le 10 ]]; then
        OUTPUT="<span background=\"#FF0000\" foreground=\"#000000\">$OUTPUT</span>"
    elif [[ $PERCENTAGE -le 15 ]]; then
        OUTPUT="<span background=\"#FFFF00\" foreground=\"#000000\">$OUTPUT</span>"
    fi

    # Show a desktop notification when the battery is low.
    if [[ $PERCENTAGE -le 10 ]]; then
        ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:anything -t 0 "BATTERY" "<span color='#FF0000' font='40px'><b>LOW BATTERY</b></span>"
    fi

    echo "$OUTPUT"
  '';

  batteryDaemonScript = pkgs.writeShellScript "waybar-battery-daemon.sh" ''
    # This daemon triggers updates for the `custom/battery` module.

    while read line; do
        if [[ $line =~ "/org/freedesktop/UPower/devices/battery_BAT" ]]; then
            ${pkgs.procps}/bin/pkill -RTMIN+${signalBattery} waybar
        fi
    done < <(${pkgs.upower}/bin/upower --monitor-detail)
  '';

  brightnessScript = pkgs.writeShellScript "waybar-brightness.sh" ''
    BR="$(${pkgs.brightnessctl}/bin/brightnessctl | head -n 2 | tail -n 1 | cut -d ' ' -f 4 | tr -d '()%')" && \
    echo "Br $BR" && \
    ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:anything -t 500 "BRIGHTNESS" "<span color='#FFFFFF' font='50px'><b>$BR</b></span>"
  '';

  clockScript = pkgs.writeShellScript "waybar-clock.sh" ''
    date +'%a %-d %b %-H:%M'
  '';

  keyboardScript = pkgs.writeShellScript "waybar-keyboard.sh" ''
    CAPS_LOCK=$(cat $(${pkgs.findutils}/bin/find /sys/class/leds -regex ".*capslock")/brightness)

    if ${pkgs.sway}/bin/swaymsg -pt get_inputs | ${pkgs.gnugrep}/bin/grep -q "Canadian (CSA)"; then
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

  keyboardCapslockDaemonScript = pkgs.writeShellScript "waybar-keyboard-capslock-daemon.sh" ''
    # This daemon triggers updates for the `custom/keyboard` module.
    # An update is triggered when the caps lock key is pressed.
    # Source: https://unix.stackexchange.com/a/428516

    sudo ${pkgs.evtest}/bin/evtest $(${pkgs.findutils}/bin/find /dev/input/by-path/ -regex ".*kbd") | while read line; do
        if [[ $line =~ "CAPSLOCK" ]]; then
            ${pkgs.procps}/bin/pkill -RTMIN+${signalKeyboard} waybar
        fi
    done
  '';

  keyboardLayoutDaemonScript = pkgs.writeShellScript "waybar-keyboard-layout-daemon.sh" ''
    # This daemon triggers updates for the `custom/keyboard` module.
    # An update is triggered when the keyboard layout changes.

    ${pkgs.sway}/bin/swaymsg -m -t subscribe '["input"]' | while read event; do
        if [[ $(echo $event | ${pkgs.jq}/bin/jq ".change") = "\"xkb_layout\"" ]]; then
            ${pkgs.procps}/bin/pkill -RTMIN+${signalKeyboard} waybar
        fi
    done
  '';

  mailScript = pkgs.writeShellScript "waybar-mail.sh" ''
    echo $(cat ${config.sops.secrets.mystring.path})
  '';

  networkScript = pkgs.writeShellScript "waybar-network.sh" ''
    # If Transmission is running, create its output
    if ${pkgs.procps}/bin/pgrep transmission &> /dev/null; then
        TRANS_OUTPUT=" <span background=\"#FFFF00\" foreground=\"#000000\">T</span>"
    fi

    # If Mullvad VPN is running, create its output
    if ${pkgs.curl}/bin/curl --connect-timeout 1 https://am.i.mullvad.net/connected 2> /dev/null | ${pkgs.gnugrep}/bin/grep -q "You are connected to Mullvad"; then
        MULLVAD_OUTPUT=" <span background=\"#FFFFFF\" foreground=\"#000000\">MullvadVPN</span>"
    fi

    # Physical state of the interface
    WIFI_STATE=$(cat "/sys/class/net/${wirelessDevice}/carrier" 2> /dev/null)

    # Create the WiFi output
    if [[ $WIFI_STATE -eq 1 ]]; then
        QUALITY=$(${pkgs.gnugrep}/bin/grep ${wirelessDevice} /proc/net/wireless | ${pkgs.gawk}/bin/awk '{ print int($3 * 100 / 70) }')
        WIFI_OUTPUT="WiFi $QUALITY%"

    	# Check if it is connected to the internet
        if ${pkgs.wget}/bin/wget -timeout=1 -q --spider https://www.google.com; then
            # If the signal is too weak, color yellow
            if [[ $QUALITY -lt 50 ]]; then
                WIFI_OUTPUT="<span background=\"#FFFF00\" foreground=\"#000000\">$WIFI_OUTPUT</span>"
            fi
        else
            # If there is no connection, color red
            WIFI_OUTPUT="<span background=\"#FF0000\" foreground=\"#000000\">$WIFI_OUTPUT</span>"
        fi
    else
        WIFI_OUTPUT="<span background=\"#FF0000\" foreground=\"#000000\">N/C</span>"
    fi

    echo "$WIFI_OUTPUT$TRANS_OUTPUT$MULLVAD_OUTPUT"
  '';

  separatorScript = pkgs.writeShellScript "waybar-separator.sh" ''
    echo "|"
  '';

  storageScript = pkgs.writeShellScript "waybar-storage.sh" ''
    AVAIL=$(${pkgs.zfs}/bin/zpool list | tail -n 1 | tr -s ' ' | cut -d ' ' -f 4)
    PERC_USED=$(${pkgs.zfs}/bin/zpool list | tail -n 1 | tr -s ' ' | cut -d ' ' -f 8 | tr -d '%')

    if [[ $PERC_USED -gt 90 ]]; then
        OUTPUT="<span background=\"#FF0000\" foreground=\"#000000\">$AVAIL</span>"
    elif [[ $PERC_USED -gt 80 ]]; then
        OUTPUT="<span background=\"#FFFF00\" foreground=\"#000000\">$AVAIL</span>"
    else
        OUTPUT="$AVAIL"
    fi

    echo "$OUTPUT"
  '';

  volumeScript = pkgs.writeShellScript "waybar-volume.sh" ''
    VOLUME="$(echo "100 * $(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2)" | ${pkgs.bc}/bin/bc | cut -d '.' -f 1)"

    MUTE=""
    if ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${pkgs.gnugrep}/bin/grep -q "MUTED"; then
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
        NOTIFIER="#FFFF00"
    fi

    echo "<span background=\"$BG\" foreground=\"$FG\">Vol $OUTPUT</span>"

    ${pkgs.libnotify}/bin/notify-send -h string:x-canonical-private-synchronous:anything -t 500 "VOLUME" "<span color=\"$NOTIFIER\" font='50px'><b>$OUTPUT</b></span>"
  '';

  volumeDaemonScript = pkgs.writeShellScript "waybar-volume-daemon.sh" ''
    # This daemon triggers updates for the `custom/volume` module.
    # An update is triggered when the headphones are inserted or pulled out.
    # Source: https://unix.stackexchange.com/a/428516

    event=$(cat /proc/bus/input/devices | ${pkgs.gnugrep}/bin/grep -A 4 Headphone | tail -n 1 | ${pkgs.gnugrep}/bin/grep -Po 'H: Handlers=\K[^ ]*')

    sudo ${pkgs.evtest}/bin/evtest "/dev/input/$event" | while read line; do
        if [[ $line =~ "HEADPHONE" ]]; then
            ${pkgs.procps}/bin/pkill -RTMIN+${signalVolume} waybar
        fi
    done
  '';

in

{
  wayland.windowManager.sway = {
    config = {
      bars = [];
      startup = [
        {
          command = "waybar";
        }
      ];
    };
    extraConfig = ''
      # Position gsimplecal in the bottom right corner
      for_window [app_id="gsimplecal"] move position ${gsimplecalX} ${gsimplecalY}
    '';
  };

  home = {
    packages = with pkgs; [
      hack-font  # Font for waybar
    ];
  };
  
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
          "custom/keyboard-capslock-daemon"
          "custom/keyboard-layout-daemon"
          "custom/separator"
          "custom/storage"
          "custom/separator"
          "custom/brightness"
          "custom/separator"
          "custom/volume"
          "custom/volume-daemon"
          "custom/separator"
          "custom/clock"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
        };

        "custom/battery" = {
          exec = batteryScript;
    	    interval = "once";
          tooltip = false;
          signal = builtins.fromJSON signalBattery;
        };

        "custom/battery-daemon" = {
          exec = batteryDaemonScript;
    	    interval = "once";
          tooltip = false;
        };

        "custom/brightness" = {
          exec = brightnessScript;
    	    interval = "once";
          tooltip = false;
          signal = builtins.fromJSON signalBrightness;
        };

        "custom/clock" = {
          exec = clockScript;
	        on-click = "${pkgs.gsimplecal}/bin/gsimplecal";
    	    interval = 5;
          tooltip = false;
        };

        "custom/keyboard" = {
          exec = keyboardScript;
    	    interval = "once";
          tooltip = false;
          signal = builtins.fromJSON signalKeyboard;
        };

        "custom/keyboard-capslock-daemon" = {
          exec = keyboardCapslockDaemonScript;
    	    interval = "once";
          tooltip = false;
        };

        "custom/keyboard-layout-daemon" = {
          exec = keyboardLayoutDaemonScript;
    	    interval = "once";
          tooltip = false;
        };

        "custom/mail" = {
          exec = mailScript;
          on-click = "echo TODO";
    	    interval = "once";
          tooltip = false;
          signal = builtins.fromJSON signalMail;
        };

        "custom/network" = {
          exec = networkScript;
    	    interval = 5;
          tooltip = false;
          signal = builtins.fromJSON signalNetwork;
        };

        "custom/separator" = {
          exec = separatorScript;
    	    interval = "once";
          tooltip = false;
        };

        "custom/storage" = {
          exec = storageScript;
    	    interval = 5;
          tooltip = false;
        };

        "custom/volume" = {
          exec = volumeScript;
    	    interval = "once";
          tooltip = false;
          signal = builtins.fromJSON signalVolume;
        };

        "custom/volume-daemon" = {
          exec = volumeDaemonScript;
    	    interval = "once";
          tooltip = false;
        };
      };
    };
  };
}

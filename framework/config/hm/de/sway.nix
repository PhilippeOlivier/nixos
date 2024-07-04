{
  config
, pkgs
, keyboardDevice
, outputDevice
, outputFreq
, outputHeight
, outputScale
, outputWidth
, signalBrightness
, signalVolume
, touchpadDevice
, ...
}:

let

  brightnessUpScript = pkgs.writeShellScript "sway-brightness-up.sh" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set +5% && ${pkgs.procps}/bin/pkill -RTMIN+${signalBrightness} waybar
  '';

  brightnessDownScript = pkgs.writeShellScript "sway-brightness-down.sh" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set 5%- && ${pkgs.procps}/bin/pkill -RTMIN+${signalBrightness} waybar
  '';

  volumeUpScript = pkgs.writeShellScript "sway-volume-up.sh" ''
    ${pkgs.wireplumber}/bin/wpctl set-volume --limit 2.0 @DEFAULT_AUDIO_SINK@ 5%+ && ${pkgs.procps}/bin/pkill -RTMIN+${signalVolume} waybar
  '';

  volumeDownScript = pkgs.writeShellScript "sway-volume-down.sh" ''
    ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${pkgs.procps}/bin/pkill -RTMIN+${signalVolume} waybar
  '';

  volumeMuteScript = pkgs.writeShellScript "sway-volume-mute.sh" ''
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ${pkgs.procps}/bin/pkill -RTMIN+${signalVolume} waybar
  '';
  
in

{
  home = {
    packages = with pkgs; [
      wl-clipboard
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    extraConfig = ''
      # If any program is full screen, do not suspend
      # Source: https://stackoverflow.com/a/68787102/1725856
      for_window [class=".*"] inhibit_idle fullscreen
      for_window [app_id=".*"] inhibit_idle fullscreen
    '';
    config = rec {
      window = {
        titlebar = false;  # Hide window title bars
      };
      modifier = config.swayModifier;
      input = {
        ${keyboardDevice} = {
          xkb_layout = "us,ca";
          xkb_variant = ",multix";
          xkb_options = "grp:lalt_lshift_toggle";
        };
        ${touchpadDevice} = {
          tap = "enabled";
          natural_scroll = "disabled";
          dwt = "enabled";
          accel_profile = "flat";
          pointer_accel = "0.5";
          scroll_method = "two_finger";
        };
      };
      output = {
        ${outputDevice} = {
	        mode = "${outputWidth}x${outputHeight}@${outputFreq}Hz";
          scale = outputScale;
        };
      };
      keybindings = {
        "${modifier}+Shift+q" = "kill";  # Kill focused window
        "${modifier}+Shift+c" = "reload";  # Reload configuration file
        "${modifier}+Shift+e" = "exec swaymsg exit";  # Exit sway
        "${modifier}+f" = "fullscreen";  # Make the current focus fullscreen
        "${modifier}+r" = "mode resize";  # Resize window
        "XF86MonBrightnessUp" = "exec ${brightnessUpScript}";
        "XF86MonBrightnessDown" = "exec ${brightnessDownScript}";
        "XF86AudioRaiseVolume" = "exec ${volumeUpScript}";
        "XF86AudioLowerVolume" = "exec ${volumeDownScript}";
        "XF86AudioMute" = "exec ${volumeMuteScript}";

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
    };
  };

  # Screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.sway.default = [ "wlr" "gtk" ];
  };

  # Desktop notifications
  services.mako = {
    enable = true;
    layer = "overlay";
  };
}

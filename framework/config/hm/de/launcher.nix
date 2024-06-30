{
  config
, pkgs
, username
, ...
}:

let
  
  launcherScript = pkgs.writeShellScript "sway-launcher.sh" ''
    ozone="--enable-features=UseOzonePlatform --ozone-platform=wayland"
    
    entries="Alacritty Blueman Chromium Discord Emacs Firefox Inkscape Libreoffice-Calc Libreoffice-Writer Lutris Signal Slack Terminal Thunar Transmission wdisplays WPA_GUI Xournal++"
    
    selected=$(printf '%s\n' $entries | ${pkgs.wofi}/bin/wofi --prompt="enter application name" --width=15% --lines=10 --insensitive --show=dmenu | ${pkgs.gawk}/bin/awk '{print tolower($1)}')
    
    case $selected in

    	alacritty|terminal)
    		alacritty & ;;

    	blueman)
    		${pkgs.blueman}/bin/blueman-manager & ;;

    	chromium)
    		chromium "$ozone" & ;;

    	discord)
    		${pkgs.discord}/bin/discord & ;;

    	emacs)
    		emacsclient -c & ;;

    	firefox)
    		MOZ_ENABLE_WAYLAND=1 firefox & ;;

    	inkscape)
    		${pkgs.inkscape}/bin/inkscape & ;;

    	libreoffice-calc)
    		${pkgs.libreoffice}/bin/libreoffice --calc & ;;

    	libreoffice-writer)
    		${pkgs.libreoffice}/bin/libreoffice --writer & ;;

    	lutris)
    		lutris & ;;

    	signal)
    		${pkgs.signal-desktop}/bin/signal-desktop & ;;

    	slack)
    		${pkgs.slack}/bin/slack & ;;

    	thunar)
    		thunar & ;;

    	transmission)
    		transmission-gtk & ;;

    	wdisplays)
    		${pkgs.wdisplays}/bin/wdisplays & ;;

    	wpa_gui)
    		${pkgs.wpa_supplicant_gui}/bin/wpa_gui & ;;

    	xournal++)
    		${pkgs.xournalpp}/bin/xournalpp & ;;
    esac
  '';
  
in

{
  home = {
    # persistence."/home/${username}/.config" = {
    #   directories = [
    #     "discord"
    #     "inkscape"
    #     "libreoffice"
    #     "Signal"
    #     "Slack"
    #     "xournalpp"
    #   ];
    # };
    
    # Prevent Discord from checking for new versions by itself
    file.".config/discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
  
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+d" = "exec ${launcherScript}";
}



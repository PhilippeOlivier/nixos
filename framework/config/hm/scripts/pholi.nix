{
  config
, pkgs
, homeDirectory
, pholiScriptDirectory
, signalNetwork
, username
, ...
}:

let
  pholi-script = pkgs.writeShellScriptBin "pholi" ''
    _pholi_help() {
        ${pholi-backup}/bin/pholi-backup help
        ${pholi-misc}/bin/pholi-misc help
        ${pholi-system}/bin/pholi-system help
        ${pholi-vpn}/bin/pholi-vpn help
    }

    case $1 in

        help)
            _pholi_help
            shift $#
            ;;

        bu|backup)
            shift
            ${pholi-backup}/bin/pholi-backup "$@"
            shift $#
            ;;

        m|misc)
            shift
            ${pholi-misc}/bin/pholi-misc "$@"
            shift $#
            ;;

        sys|system)
            shift
            ${pholi-system}/bin/pholi-system "$@"
            shift $#
            ;;

        vpn)
            shift
            ${pholi-vpn}/bin/pholi-vpn "$@"
            shift $#
            ;;

        *)
            if [ -n "$1" ]; then
                echo "Error: Unknown command: pholi $*"
            fi
            _pholi_help
            shift $#
            ;;

    esac
  '';

  pholi-backup = pkgs.writeShellScriptBin "pholi-backup" ''
    _pholi_backup_help() {
        echo "backup [cloud|dock|undock]"
        echo "    cloud: Backblaze B2"
        echo "    dock: Dock backup drive"
        echo "    undock: Undock backup drive"
    }

    if [ $# -gt 1 ]; then
        echo "Error: Too many arguments: pholi backup $1"
        _pholi_backup_help

    elif [ "$1" = "help" ]; then
         _pholi_backup_help

    elif [ "$1" = "cloud" ]; then
         echo TODO

    elif [ "$1" = "dock" ]; then
        # TODO: clean this up after homelab is set up
        ssh -i /home/pholi/.ssh/id_ed25519 homelab@192.168.100.82 '/home/homelab/.nixos-extra/scripts/backup/dock.sh'

    elif [ "$1" = "undock" ]; then
        # TODO: clean this up after homelab is set up
        ssh -i /home/pholi/.ssh/id_ed25519 homelab@192.168.100.82 '/home/homelab/.nixos-extra/scripts/backup/undock.sh'

    else
        echo "Error: Unknown command: pholi backup $1"
        _pholi_backup_help

    fi
  '';

  pholi-misc = pkgs.writeShellScriptBin "pholi-misc" ''
    _pholi_misc_help() {
        echo "misc [kaamelott|youtube]"
        echo "    kaamelott|k: Continue watching Kaamelott"
        echo "    youtube|yt: Get Youtube song from active Firefox tab"
    }

    if [ $# -gt 1 ]; then
        echo "Error: Too many arguments: pholi misc $1"
        _pholi_misc_help

    elif [ "$1" = "help" ]; then
         _pholi_misc_help

    elif [ "$1" = "kaamelott" ] || [ "$1" = "k" ]; then
        nohup ${pkgs.mpv}/bin/mpv --fs --save-position-on-quit ${homeDirectory}/${pholiScriptDirectory}/kaamelott_1_a_4.webm & &> /dev/null
	      disown
	      exit

    elif [ "$1" = "youtube" ] || [ "$1" = "yt" ]; then
        echo TODO

    else
        echo "Error: Unknown command: pholi misc $1"
        _pholi_misc_help

    fi
  '';

  pholi-system = pkgs.writeShellScriptBin "pholi-system" ''
    _pholi_system_help() {
        echo "system [clean|rebuild|update]"
        echo "    clean: Clean the system"
        echo "    rebuild: Rebuild the system"
        echo "    update: Update the flake"
    }

    if [ $# -gt 1 ]; then
        echo "Error: Too many arguments: pholi system $1"
        _pholi_system_help

    elif [ "$1" = "clean" ]; then
        echo TODO

    elif [ "$1" = "rebuild" ]; then
        sudo nixos-rebuild switch --flake ${homeDirectory}/nixos/framework/config

    elif [ "$1" = "update" ]; then
        sudo nix flake update ${homeDirectory}/nixos/framework/config

    else
        echo "Error: Unknown command: pholi system $1"
        _pholi_system_help

    fi
  '';

  pholi-vpn = pkgs.writeShellScriptBin "pholi-vpn" ''
    _pholi_vpn_help() {
        echo "vpn [off|on|status|toggle|torrent] (default toggle)"
        echo "    off: Turn off VPN"
        echo "    on: Turn on VPN"
        echo "    status: VPN connection status"
        echo "    toggle: Turn on/off VPN"
        echo "    torrent|t: Toggle vpn+torrent"
    }

    _pholi_connected_to_mullvad() {
        if ${pkgs.curl}/bin/curl --silent https://am.i.mullvad.net/connected | ${pkgs.gnugrep}/bin/grep -q "You are connected to Mullvad"; then
            return 0
        else
            return 1
        fi
    }

    _pholi_transmission_active() {
        if ${pkgs.procps}/bin/pgrep transmission > /dev/null; then
            return 0
        else
            return 1
        fi
    }

    _pholi_vpn_connect() {
        ${pkgs.mullvad-vpn}/bin/mullvad lockdown-mode set on
        ${pkgs.mullvad-vpn}/bin/mullvad connect
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.procps}/bin/pkill -RTMIN+${signalNetwork} waybar
        echo "VPN connected"
    }

    _pholi_vpn_disconnect() {
        if _pholi_transmission_active; then
            set -e
            ( ${pkgs.procps}/bin/pkill -15 transmission & &> /dev/null )
            set +e
            ${pkgs.procps}/bin/pkill -RTMIN+${signalNetwork} waybar
            echo "Transmission stopped"
        fi
        ${pkgs.mullvad-vpn}/bin/mullvad disconnect
        ${pkgs.mullvad-vpn}/bin/mullvad lockdown-mode set off
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.procps}/bin/pkill -RTMIN+${signalNetwork} waybar
        echo "VPN disconnected"
    }

    if [ $# -gt 1 ]; then
        echo "Error: Too many arguments: pholi vpn $1"
        _pholi_vpn_help

    elif [ "$1" = "off" ]; then
        if _pholi_connected_to_mullvad; then
            _pholi_vpn_disconnect
        else
            echo "VPN is already disconnected"
        fi

    elif [ "$1" = "on" ]; then
        if ! _pholi_connected_to_mullvad; then
            _pholi_vpn_connect
        else
            echo "VPN is already connected"
        fi

    elif [ "$1" = "status" ]; then
        if _pholi_connected_to_mullvad; then
            echo "VPN is connected"
        else
            echo "VPN is disconnected"
        fi

    elif [ "$1" = "toggle" ] || [ -z "$1" ]; then
        if ! _pholi_connected_to_mullvad; then
            _pholi_vpn_connect
        else
            _pholi_vpn_disconnect
        fi

    elif [ "$1" = "torrent" ] || [ "$1" = "t" ]; then
        # VPN off, Transmission off -> VPN on, Transmission on
        if ! _pholi_connected_to_mullvad && ! _pholi_transmission_active; then
            set -e
            _pholi_vpn_connect
            set +e
            ( ${pkgs.transmission_4-gtk}/bin/transmission-gtk & &> /dev/null )
            ${pkgs.procps}/bin/pkill -RTMIN+${signalNetwork} waybar
            echo "Transmission started"

        # VPN on, Transmission off -> (VPN on), Transmission on
        elif _pholi_connected_to_mullvad && ! _pholi_transmission_active; then
            echo "VPN already on"
            ( ${pkgs.transmission_4-gtk}/bin/transmission-gtk & &> /dev/null )
            ${pkgs.procps}/bin/pkill -RTMIN+${signalNetwork} waybar
            echo "Transmission started"

        # VPN off, Transmission on -> VPN on, (Transmission on), warning
        elif ! _pholi_connected_to_mullvad && _pholi_transmission_active; then
            _pholi_vpn_connect
            echo "WARNING: Transmission started before VPN"

        # VPN on, Transmission on -> VPN off, Transmission off
        elif _pholi_connected_to_mullvad && _pholi_transmission_active; then
            # Disconnecting automatically shuts down Transmission too
            _pholi_vpn_disconnect
        fi

    else
        echo "Error: Unknown command: pholi vpn $1"
        _pholi_vpn_help

    fi
  '';
  
in

{  
  sops.secrets = {
    ntfyTopic = {};
  };

  home = {
    packages = with pkgs; [
      pholi-script
    ];
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          pholiScriptDirectory
        ];
      };
    };
  };
}

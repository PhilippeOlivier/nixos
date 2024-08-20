{
  config
, pkgs
, homeDirectory
, pholiScriptDirectory
, username
, ...
}:

let
  pholi-script = pkgs.writeShellScriptBin "pholi" ''
    _pholi_help() {
        ${pholi-backup}/bin/pholi-backup help
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
        echo "backup [dock|undock|cloud]"
        echo "    dock: Dock backup drive"
        echo "    undock: Undock backup drive"
        echo "    cloud: Backblaze B2"
    }

    if [ $# -gt 1 ]; then
        echo "Error: Too many arguments"
        _pholi_backup_help
    elif [ "$1" = "dock" ]; then
        # TODO: clean this up after homelab is set up
        ssh -i /home/pholi/.ssh/id_ed25519 homelab@192.168.100.82 '/home/homelab/.nixos-extra/scripts/backup/dock.sh'
    elif [ "$1" = "undock" ]; then
        # TODO: clean this up after homelab is set up
        ssh -i /home/pholi/.ssh/id_ed25519 homelab@192.168.100.82 '/home/homelab/.nixos-extra/scripts/backup/undock.sh'
    elif [ "$1" = "cloud" ]; then
         echo TODO
    elif [ "$1" = "help" ]; then
         _pholi_backup_help
    else
        echo "Error: Unknown command: pholi backup $1"
        _pholi_backup_help
    fi
  '';

in

{  
  sops.secrets = {
    hnTerms = {};
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

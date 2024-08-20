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
    echo TODO $1
    case $1 in
        backup)
          echo BAKCUP
          # try to include another script in here
          ;;
        *)
          echo NO CMD
          ;;
    esac
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

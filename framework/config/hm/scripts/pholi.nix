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
    # try to include another script in here
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

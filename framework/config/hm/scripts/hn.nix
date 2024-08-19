{
  config
, pkgs
, hnDirectory
, homeDirectory
, username
, ...
}:

let
  hn-script = pkgs.writeShellScriptBin "hn-script" ''
    echo asdf
  '';

in

{  
  sops.secrets.ntfyTopic = {};
  
  systemd.user.services."hn" = {
    Unit = {
      Description = "Check for interesting replies to whoshiring on HN";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${hn-script}/bin/hn-script";
    };
  };
  
  systemd.user.timers."hn" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      Unit = "hn.service";
      OnCalendar = "*-*-* 3:00:00";
      Persistent = true;
    };
  };

  home = {
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          hnDirectory
        ];
      };
    };
  };
}

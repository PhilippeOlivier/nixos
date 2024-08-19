{
  pkgs
, eyepatchDirectory
, username
, ...
}:

let
  eyepatch-script = pkgs.writeShellScriptBin "eyepatch-script" ''
    echo "Eyepatch: error track file not found (send that to ntfy)"
  '';
in

{  
  sops.secrets.ntfyTopic = {};
  
  systemd.user.services."eyepatch" = {
    Unit = {
      Description = "Check for new episodes with Eyepatch";
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${eyepatch-script}/bin/eyepatch-script";
    };
  };
  
  systemd.user.timers."eyepatch" = {
    Install.WantedBy = [ "timers.target" ];
    Timer = {
      Unit = "eyepatch.service";
      OnCalendar = "*-*-* 21:03:00";
      # OnCalendar = "*-*-* 3:00:00";
      Persistent = true;
    };
  };

  home = {
    persistence = {
      "/snap/home/${username}" = {
        directories = [
          eyepatchDirectory
        ];
      };
    };
  };
}

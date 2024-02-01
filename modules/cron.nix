{ config, pkgs, ... }:


{

  # rename this file to services.nix
  
  # systemd.services."eyepatch-service" = {
  #   description = "Eyepatch";
  #   path = [ pkgs.curl pkgs.jq pkgs.toybox ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.bash}/bin/bash /home/pholi/.nixos-extra/scripts/eyepatch/eyepatch.sh";
  #     User = "pholi";
  #     Group = "users";
  #   };
  # };

  # systemd.timers."eyepatch-service" = {
  #   description = "Eyepatch timer";
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnCalendar = "*-*-* 3:00:00";
  #     Unit = "eyepatch-service.service";
  #   };
  # };

  # Still TODO, try on feb 1-2
  # systemd.services."hn-service" = {
  #   description = "HN jobs";
  #   wantedBy = [ "multi-user.target" ];  # DELETE
  #   path = [ pkgs.curl pkgs.jq pkgs.toybox ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.bash}/bin/bash /home/pholi/.nixos-extra/scripts/hn/hn.sh";
  #     User = "pholi";
  #     Group = "users";
  #   };
  # };

  # systemd.timers."hn-service" = {
  #   description = "HN jobs timer";
  #   wantedBy = [ "timers.target" ];
  #   timerConfig = {
  #     OnCalendar = "*-*-* *:38:00";
  #     Unit = "hn-service.service";
  #   };
  # };
}

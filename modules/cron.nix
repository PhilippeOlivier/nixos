{ config, pkgs, ... }:

# {
#   services.cron = {
#     enable = true;
#     systemCronJobs = [
#       "*/1 * * * * pholi /home/pholi/.nixos-extra/scripts/cron/test.sh"
#     ];
#   };
# }

# 0 3 * * * /home/pholi/.nixos-extra/scripts/cron/eyepatch.sh
# 0 * * * * /home/pholi/.nixos-extra/scripts/cron/hackernews.sh
# 0 3 * * 1 /usr/bin/python /home/pholi/.nixos-extra/scripts/cron/alcohol.py

#https://www.reddit.com/r/NixOS/comments/uc90q9/problems_with_crontab/

{
  systemd.services."eyepatch-service" = {
    description = "Eyepatch";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.curl pkgs.jq ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/pholi/.nixos-extra/scripts/eyepatch/eyepatch.sh";
      User = "pholi";
      Group = "users";
    };
  };

  systemd.timers."eyepatch-service" = {
    description = "Eyepatch timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 8:41:00"; #"*-*-* 3:00:00";
      Persistent = true;
      Unit = "eyepatch-service.service";
    };
  };

  # below works
  systemd.services."test-service" = {
    description = "My test service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash /home/pholi/.nixos-extra/scripts/cron/test.sh";
      User = "pholi";
      Group = "users";
    };
  };

  systemd.timers."test-service" = {
    description = "The timer for my test service";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitActiveSec = "1m";
      Unit = "test-service.service";
    };
  };
}

  # scripts/hn
  # scripts/eyepatch
  # scripts/alcohol

{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/1 * * * * pholi /home/pholi/.nixos-extra/scripts/cron/test.sh"
    ];
  };
}

# 0 3 * * * /home/pholi/.nixos-extra/scripts/cron/eyepatch.sh
# */5 * * * * /home/pholi/.nixos-extra/scripts/mail/ntfy.sh
# 0 * * * * /home/pholi/.nixos-extra/scripts/cron/hackernews.sh
# 0 3 * * 1 /usr/bin/python /home/pholi/.nixos-extra/scripts/cron/alcohol.py

{config,pkgs, username, ...}:

{
  sops.secrets."ntfy_topic" = {
    owner = config.users.users.${username}.name;
    group = config.users.users.${username}.group;
  };

  systemd.services."test" = {
    wants = [
      "graphical.target"
      "network-online.target"
    ];
    script = ''
      touch /home/pholi/$(cat ${config.sops.secrets."ntfy_topic".path})
    '';
    serviceConfig = {
      Type = "oneshot";
      User = username;
      Group = "users";
    };
  };
}

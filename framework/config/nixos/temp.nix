{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {
    owner = config.users.users.pholi.name;
    group = config.users.users.pholi.group;
  };

  systemd.services."test" = {
    wantedBy = ["multi-user.target"];
    script = ''
      touch /home/pholi/$(cat ${config.sops.secrets."ntfy_topic".path})
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pholi";
      Group = "users";
    };
  };
}

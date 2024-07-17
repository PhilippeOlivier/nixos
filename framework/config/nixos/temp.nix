{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  systemd.services."test" = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        touch /home/pholi/asdf
      '';
      User = "pholi";
      Group = "users";
    };
    # script = ''
    #   touch /home/pholi/asdf #${config.sops.secrets."ntfy_topic".path}
    # '';
  };
}

{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};
  # ${config.sops.secrets."ntfy_topic".path}
  systemd.services."test" = {
    script = ''
      touch /home/pholi/asdf
    # '';
    serviceConfig = {
      Type = "oneshot";
      # ExecStart = ''
      #   touch /home/pholi/asdf
      # '';
      User = "pholi";
      Group = "users";
    };
  };
}

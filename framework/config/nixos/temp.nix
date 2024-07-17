{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  systemd.services."test" = {
    script = ''
      touch /home/pholi/${config.sops.secrets."ntfy_topic".path}
    '';
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

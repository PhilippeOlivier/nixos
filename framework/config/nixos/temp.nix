{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  systemd.services."test" = {
    script = ''
      touch /home/pholi/asdf #${config.sops.secrets."ntfy_topic".path}
    '';
  };
}

{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  systemd.services."test" = {
    script = ''
      touch /home/pholi/$(cat ${config.sops.secrets."ntfy_topic".path})
    '';
    # after = [ "sops-nix.service" ];
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

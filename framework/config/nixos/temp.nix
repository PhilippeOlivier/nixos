{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  systemd.services."test" = {
    script = ''
      touch /home/pholi/asdf
      touch /home/pholi/$(sudo cat ${config.sops.secrets."ntfy_topic".path})
      touch /home/pholi/ASDF
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

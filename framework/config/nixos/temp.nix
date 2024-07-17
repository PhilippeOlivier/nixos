{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {
    owner = config.users.users.pholi.name;
    group = config.users.users.pholi.group;
  };

  # 
        # touch /home/pholi/$(sudo cat /run/secrets/ntfy_topic)
  systemd.services."test" = {
    wantedBy = ["multi-user.target"];
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

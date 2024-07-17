{config,pkgs, ...}:

{
  sops.secrets."ntfy_topic" = {};

  # 
        # touch /home/pholi/$(sudo cat /run/secrets/ntfy_topic)
  systemd.services."test" = {
    wantedBy = ["multi-user.target"];
    path = [ pkgs.sudo ];
    script = ''
      #touch /home/pholi/$(sudo cat ${config.sops.secrets."ntfy_topic".path})
      sudo touch /home/pholi/asdf
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

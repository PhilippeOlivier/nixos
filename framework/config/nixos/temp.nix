{config,pkgs, username, ...}:

{
  sops.secrets."ntfy_topic" = {
    owner = config.users.users.${username}.name;
    group = config.users.users.${username}.group;
  };


  # systemd.services."test" = {
  #   requires = [
  #     "network-online.target"
  #   ];
  #   after = [
  #     "network-online.target"
  #   ];
  #   script = ''
  #     touch /home/pholi/$(cat ${config.sops.secrets."ntfy_topic".path})
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     #ExecStartPre = "sleep 10";
  #     User = username;
  #     Group = "users";
  #   };
  # };


  # fetch-mail.service starts after network is online at reboot, and also every time the network goes back online
  
  services.networkd-dispatcher = {
    enable = true;

    rules."fetch-mail" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}
        systemctl restart fetch-mail.service
      '';
    };
  };
  
  systemd.services."fetch-mail" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    script = ''
      echo asdf
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pholi";
      Group = "users";
    };
  };
}

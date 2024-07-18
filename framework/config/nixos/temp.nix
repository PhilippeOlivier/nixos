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

  # restart every time network comes online: https://unix.stackexchange.com/questions/725834/systemd-unit-auto-restart-when-network-changes

  systemd.network = {
    enable = true;
    networks."10-wlp4s0" = {
      matchConfig.Name = "wlp4s0";
      networkConfig.DHCP = "yes";
      networkConfig.Address = "192.168.100.100/24";
    };
  };
  networking.useNetworkd = true;
  
  services.networkd-dispatcher = {
    enable = true;

    rules."test" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}
        #echo ASDF
        systemctl restart test.service
      '';
    };
  };
  
  systemd.services."test" = {
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

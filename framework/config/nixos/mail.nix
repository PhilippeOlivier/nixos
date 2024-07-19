{config,pkgs, username, ...}:

# let
#   mail-fetch script...
# in

{


  # fetch-mail.service starts after network is online at reboot, and also every time the network goes back online
  
  # Required for `networkd-dispatcher`
  networking.useNetworkd = true;
  
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
    script = ''
      sudo systemctl --user -M pholi@ restart fetch-mail.service
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "pholi";
      Group = "users";
    };
  };
  
  # systemd.services."fetch-mail" = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   requires = [ "network-online.target" ];
  #   after = [ "network-online.target" ];
  #   script = ''
  #     echo asdf
  #   '';
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "pholi";
  #     Group = "users";
  #   };
  # };
}

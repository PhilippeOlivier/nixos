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

    # this rule restarts the systemd "fetch-mail" system service
    rules."fetch-mail" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}
        ${pkgs.sudo}/bin/sudo systemctl --user -M pholi@ restart fetch-mail.service
        #systemctl restart fetch-mail.service
      '';
    };
  };

  # this system service restarts the systemd user service "fetch-mail"
  # TODO: can we just put this script in networkd-dispatcher instead?
  systemd.services."fetch-mail" = {  # <- rename to fetch-mail-system and the other one to fetch-mail-user
    enable = true;
    script = ''
      ${pkgs.sudo}/bin/sudo systemctl --user -M pholi@ restart fetch-mail.service
    '';
    serviceConfig = {
      Type = "oneshot";
      # User = "pholi";
      # Group = "users";
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

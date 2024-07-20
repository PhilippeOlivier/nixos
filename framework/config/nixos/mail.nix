{config,pkgs, username, ...}:

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
systemctl --user -M pholi@ restart fetch-mail.service
        #${pkgs.sudo}/bin/sudo systemctl --user -M pholi@ restart fetch-mail.service
        #systemctl restart fetch-mail.service
      '';
    };
  };
}

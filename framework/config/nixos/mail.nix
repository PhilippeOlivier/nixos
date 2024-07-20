{
  pkgs
, ...
}:

{
  # Required for `networkd-dispatcher`
  networking.useNetworkd = true;
  
  services.networkd-dispatcher = {
    enable = true;

    # This rule restarts the systemd user service `fetch-mail` every time the routable state is reached
    rules."fetch-mail" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}
        ${pkgs.sudo}/bin/sudo systemctl --user -M pholi@ restart fetch-mail.service
      '';
    };
  };
}

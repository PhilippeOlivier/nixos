{
  pkgs
, username
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

        # System and user services cannot depend on each other, this is why we do this
        ${pkgs.sudo}/bin/sudo systemctl --user -M ${username}@ restart fetch-mail.service
      '';
    };
  };
}

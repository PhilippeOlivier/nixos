
{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
      WantedBy = [ "multi-user.target" ];
      Requires = [ "network-online.target" ];
      After = [ "network-online.target" ];  
    };

    Service = {
      ExecStart = ''
        echo asdf
      '';
      Type = "oneshot";
    };
  };
}

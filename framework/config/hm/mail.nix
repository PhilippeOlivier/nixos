
{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
      Requires = [ "network-online.target" ];
      After = [ "network-online.target" ];  
    };

    Service = {
      ExecStart = ''
        echo asdf
      '';
      Type = "oneshot";
    };
    Install.WantedBy = [ "multi-user.target" ];
  };
}

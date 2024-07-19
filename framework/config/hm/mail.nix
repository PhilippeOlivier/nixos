
{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
      Requires = [ "multi-user.target" ];
      After = [ "multi-user.target" ];  
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

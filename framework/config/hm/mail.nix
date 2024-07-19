
{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
    };

    Service = {
      ExecStart = ''
        echo asdf
      '';
      Type = "oneshot";
    };
  };

}

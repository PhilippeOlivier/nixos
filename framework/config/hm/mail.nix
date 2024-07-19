{pkgs, ...}:
{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
    };

    Service = {
      ExecStart = ''
        #!${pkgs.runtimeShell}
        echo asdf
      '';
      Type = "oneshot";
    };
  };

}

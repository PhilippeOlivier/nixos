{pkgs, ...}:


{
  systemd.user.services."fetch-mail" = {
    Unit = {
      Description = "ASFDASDFA";
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScriptBin "fetch-mail" ''
          echo asdf
        ''}/bin/fetch-mail";
    };
  };

}

{pkgs, ...}:

{
  systemd.services."test" = {
    description = "test";
    path = [ pkgs.curl ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "echo asdf";#"${pkgs.bash}/bin/bash ";
      User = "pholi";
      Group = "users";
    };
  };
}

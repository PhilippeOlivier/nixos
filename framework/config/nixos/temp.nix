{pkgs, ...}:

{
  systemd.services."test" = {
    description = "test";
    path = [ pkgs.curl ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "touch /home/pholi/systemdtest";#"${pkgs.bash}/bin/bash ";
      User = "pholi";
      Group = "users";
    };
  };
}

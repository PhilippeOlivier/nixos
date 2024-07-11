{pkgs, ...}:

{
  systemd.services."myuser@" = {
    serviceConfig.ExecStart = 
      let
        script = pkgs.writeScript "myuser-start" ''
        #!${pkgs.runtimeShell}
        user="$1"
        echo Hi, $user";
      '';
      in "${script} %u";
  };
}

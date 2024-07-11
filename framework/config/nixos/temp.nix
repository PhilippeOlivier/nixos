{pkgs, ...}:

{
  systemd.services."test" = {
    script = ''
      echo ASDF
    '';
  };
}

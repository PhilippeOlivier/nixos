{pkgs, ...}:

{
  systemd.services."test" = {
    script = ''
      touch /home/pholi/ASDF
    '';
  };
}

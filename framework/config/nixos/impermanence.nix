{
  lib
, username
, ...
}:

{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/root@blank
  '';

  # Required in order to be able to set `allowOther = true`
  programs.fuse.userAllowOther = true;
  
  # These should persist and be backed up
  environment.persistence = {
    "/snap" = {
      hideMounts = true;

      directories = [
        "/var/cache"
        "/var/log"
        "/var/lib/fprint"
        "/var/lib/systemd"
      ];

      files = [
        "/etc/asdf"
        "/etc/machine-id"
      ];
    };
    
    "/nosnap" = {
      hideMounts = true;

      directories = [
      ];

      files = [
      ];
    };
  };
}

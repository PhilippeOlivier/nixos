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
  
  environment.persistence = {
    # This should persist and be backed up
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

    # This should persist but not be backed up
    "/nosnap" = {
      hideMounts = true;

      directories = [
      ];

      files = [
      ];
    };
  };
}

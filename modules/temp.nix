{ config, pkgs, ... }:

{
  # This is required to run the backup scripts without entering a password
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/cryptsetup";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/zpool";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/pholi/bin/mkdir";  # TODO: change to homelab
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/wrappers/bin/mount";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/wrappers/bin/umount";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/pholi/bin/rmdir";  # TODO: change to homelab
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/pholi/bin/udisksctl";  # TODO: change to homelab
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

{ config, pkgs, ... }:

{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        # runAs = "root"; # <- ?
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/wrappers/bin/mount";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/cryptsetup";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

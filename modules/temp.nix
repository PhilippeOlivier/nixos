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
            command = "/run/wrappers/bin/mount";  # MUST STILL USER sudo but not pw should be asked
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

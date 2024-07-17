{
  config
, pkgs
, username
, ...
}:

let

  lockScreenScript = pkgs.writeShellScript "sway-lock-screen.sh" ''
    ${pkgs.swayidle}/bin/swayidle -w \
    timeout 1 'swaylock && swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on" && pkill -15 --newest swayidle'
  '';
  
in

{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts = [
      {
        timeout = 540;
        command = "${pkgs.libnotify}/bin/notify-send -t 60000 -h string:x-canonical-private-synchronous:anything \"IDLE WARNING\" \"<span color='#FF0000' font='39px'><b>SUSPEND SOON</b></span>\"";
        resumeCommand = "${pkgs.procps}/bin/pkill mako; ${pkgs.mako}/bin/mako &";
      }
      {
        timeout = 600;
        command = "${config.programs.swaylock.package}/bin/swaylock && ${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      show-failed-attempts = true;
      daemonize = true;
      show-keyboard-layout = true;
      indicator-caps-lock = true;
    };
  };

  systemd.user.services."swaylock-suspend" = {
    description = "Lock screen before suspend";
    before = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    script = "XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 ${pkgs.swaylock}/bin/swaylock";
    serviceConfig = {
      Type = "forking";
      User = username;
      Group = "users";
    };
  };

  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+l" = "exec ${lockScreenScript}";
}

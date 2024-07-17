{
  pkgs
, username
, ...
}:

{
  # Required for sway with HM
  security.polkit.enable = true;

  # Required for swaylock to work
  security.pam.services.swaylock = {};

  systemd.services."swaylock-suspend" = {
    description = "Lock screen before suspend";
    # before = [
    #   "suspend.target"
    # ];
    wantedBy = [
      "suspend.target"
    ];
    script = "XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-1 ${pkgs.swaylock}/bin/swaylock";
    serviceConfig = {
      Type = "forking";
      User = username;
      Group = "users";
    };
  };
}

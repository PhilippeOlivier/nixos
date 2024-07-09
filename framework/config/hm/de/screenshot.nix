{
  pkgs
, screenshotDirectory
, username
, ...
}:

let
  
  screenshotScript = pkgs.writeShellScript "sway-screenshot.sh" ''
    mkdir -p ${screenshotDirectory}
    filename="${screenshotDirectory}/$(date '+%Y-%m-%d_%H%M%S.png')"
    ${pkgs.sway-contrib.grimshot}/bin/grimshot save area $filename
  '';
  
in

{
  wayland.windowManager.sway.config.keybindings."Print" = "exec ${screenshotScript}";
}

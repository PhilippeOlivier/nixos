{
  pkgs
, username
, screenshotDirectory
, screenshotPath
, ...
}:

let
  
  screenshotScript = pkgs.writeShellScript "sway-screenshot.sh" ''
    mkdir -p ${screenshotPath}
    filename="${screenshotPath}/$(date '+%Y-%m-%d_%H%M%S.png')"
    ${pkgs.sway-contrib.grimshot}/bin/grimshot save area $filename
  '';
  
in

{
  wayland.windowManager.sway.config.keybindings."Print" = "exec ${screenshotScript}";

  home.persistence = {
    "/snap/home/${username}" = {
      allowOther = true;

      directories = [
        screenshotDirectory
      ];
    };
  };
}

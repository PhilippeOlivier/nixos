{
  pkgs
, homeDirectory
, screenshotDirectory
, username
, ...
}:

let
  
  #screenshotDirectoryPath = "${homeDirectory}/.config/pholi-screenshots";

  screenshotScript = pkgs.writeShellScript "sway-screenshot.sh" ''
    mkdir -p ${screenshotDirectory}
    filename="${screenshotDirectory}/$(date '+%Y-%m-%d_%H%M%S.png')"
    ${pkgs.sway-contrib.grimshot}/bin/grimshot save area $filename
  '';
  
in

{
  wayland.windowManager.sway.config.keybindings."Print" = "exec ${screenshotScript}";

  home.persistence."/snap/home/${username}" = {
    directories = [
      ${screenshotDirectory}
      #".config/pholi-screenshots"
    ];
  };
}

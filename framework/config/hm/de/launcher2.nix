{
  config
, pkgs
, username
, ...
}:

let
  
  launcherScript = pkgs.writeShellScript "sway-launcher2.sh" ''
  XDG_DATA_DIRS="/home/pholi/.config/pholi-desktop-entries" ${pkgs.wofi}/bin/wofi --show=drun
  '';
  
in

{
  home = {
    # persistence."/snap/home/${username}/.config" = {
    #   directories = [
    #     "discord"
    #     "inkscape"
    #     "libreoffice"
    #     "Signal"
    #     "Slack"
    #     "xournalpp"
    #   ];
    # };
    
    # Prevent Discord from checking for new versions by itself
    file.".config/discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
  
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+d" = "exec ${launcherScript}";
}



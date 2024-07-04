{
  config
, pkgs
, username
, ...
}:

let
  
  launcherScript = pkgs.writeShellScript "sway-launcher.sh" ''
    # 1. Remove `.desktop` from every file in the desktop entries directoy
    # 2. `wofi` shows these clean entries
    # 3. The complete path and `.desktop` extension are added to the selected entry
    # 4. `dex` executes the associated desktop entry
    printf '%s\n' $(basename -s .desktop $(ls /home/pholi/.config/pholi-desktop-entries/applications)) | ${pkgs.wofi}/bin/wofi --prompt="enter application name" --width=15% --lines=10 --insensitive --show=dmenu | ${pkgs.gawk}/bin/awk 'BEGIN{printf("/home/pholi/.config/pholi-desktop-entries/applications/")} {printf($0)} END{printf(".desktop")}' | xargs ${pkgs.dex}/bin/dex
  '';
  
in

{
  # home = {
  #   # persistence."/snap/home/${username}/.config" = {
  #   #   directories = [
  #   #     "discord"
  #   #     "inkscape"
  #   #     "libreoffice"
  #   #     "Signal"
  #   #     "Slack"
  #   #     "xournalpp"
  #   #   ];
  #   # };
    
  #   # Prevent Discord from checking for new versions by itself
  #   file.".config/discord/settings.json".text = ''
  #     {
  #       "SKIP_HOST_UPDATE": true
  #     }
  #   '';
  # };
  
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+d" = "exec ${launcherScript}";
}



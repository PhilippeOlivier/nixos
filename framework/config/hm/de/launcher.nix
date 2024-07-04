{
  config
, pkgs
, desktopEntriesDirectory
, username
, ...
}:

let
  
  launcherScript = pkgs.writeShellScript "sway-launcher.sh" ''
    # 1. Remove `.desktop` from every file in the desktop entries directoy
    # 2. `wofi` shows these clean entries
    # 3. The complete path and `.desktop` extension are added to the selected entry
    # 4. `dex` executes the associated desktop entry
    printf '%s\n' $(basename -s .desktop $(ls ${desktopEntriesDirectory})) | ${pkgs.wofi}/bin/wofi --prompt="enter application name" --width=15% --lines=10 --insensitive --show=dmenu | ${pkgs.gawk}/bin/awk 'BEGIN{printf("${desktopEntriesDirectory}/")} {printf($0)} END{printf(".desktop")}' | xargs ${pkgs.dex}/bin/dex
  '';
  
in

{ 
  wayland.windowManager.sway.config.keybindings."${config.swayModifier}+d" = "exec ${launcherScript}";
}



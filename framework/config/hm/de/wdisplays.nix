{
  config
, pkgs
, ...
}:

let
  
  wdisplaysScript = pkgs.writeShellScript "sway-wdisplays.sh" ''
  ${pkgs.wdisplays}/bin/wdisplays
  '';
  
in

{
  wayland.windowManager.sway = {
    config.keybindings."${config.swayModifier}+p" = "exec ${wdisplaysScript}";  # F9 sends the signal: Windows+P

    extraConfig = ''
      for_window [app_id="wdisplays"] floating enable
      for_window [app_id="wdisplays"] [floating] resize set 1024 768
      for_window [app_id="wdisplays"] move position center
    '';
  };
}

{
  config
, lib
, ...
}:

{
  imports = [
    ./kanshi.nix
    ./launcher.nix
    #./screenshot.nix
    ./sway.nix
    ./swayidle-swaylock.nix
    ./terminal.nix
    ./waybar.nix
    ./wdisplays.nix
  ];

  options = {
    swayModifier = lib.mkOption {
      type = lib.types.str;
      default = "Mod4";  # The sway modifier key is the Super/Windows key
    };
  };
}

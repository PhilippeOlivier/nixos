{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      xfce.thunar
    ];
    # file.".config/transmission/settings.json".text = ''

    # '';
  };
}

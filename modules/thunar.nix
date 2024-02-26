{ config, pkgs, ... }:

{

  # Allows trash for Thunar
  programs.thunar.enable = true;
  # services.gvfs.enable = true;
  services.tumbler.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
  ];

  programs.file-roller.enable = true;
#  programs.xfconf.enable = false;
}

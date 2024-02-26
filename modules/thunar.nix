{ config, pkgs, ... }:

{
  programs.thunar.enable = true;
  services.tumbler.enable = true;
  # services.gvfs.enable = true;  # Trash

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
  ];

  programs.file-roller.enable = true;
}

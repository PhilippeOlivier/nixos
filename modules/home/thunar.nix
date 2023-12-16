{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      gnome.file-roller
      gnome.gvfs
      lrzip
      p7zip
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
    ];
    # file.".config/xfce4/help.rc".text = ''
    #   auto-online=false
    # '';
    # file.".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".source = "/home/pholi/nixos/thunar.xml";
  };
}

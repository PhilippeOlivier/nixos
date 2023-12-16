{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    zathura
  ];
  home.file.".config/zathura/zathurarc".text = ''
    set guioptions none
  '';
}

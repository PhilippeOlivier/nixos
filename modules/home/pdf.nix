{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      diffpdf
      qpdf
      xournalpp
      zathura
    ];
    file.".config/zathura/zathurarc".text = ''
      set guioptions none
    '';
  };
}

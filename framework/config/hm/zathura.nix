{
  pkgs
, ...
}:

{
  home = {
    packages = with pkgs; [
      zathura
    ];
    
    file.".config/zathura/zathurarc".text = ''
      set guioptions none
    '';
  };
}

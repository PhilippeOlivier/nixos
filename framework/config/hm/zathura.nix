{
  pkgs
, username
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

    persistence."/nosnap/home/${username}" = {
      directories = [
        ".local/share/zathura"
      ];
    };
  };
}

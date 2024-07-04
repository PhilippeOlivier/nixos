{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      inkscape
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/inkscape"
      ];
    };
  };
}

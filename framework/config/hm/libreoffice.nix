{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      libreoffice
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}

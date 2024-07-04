{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      signal-desktop
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/Signal"
      ];
    };
  };
}

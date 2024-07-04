{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      xournalpp
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/xournalpp"
      ];
    };
  };
}

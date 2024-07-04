{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      slack
    ];
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/Slack"
      ];
    };
  };
}

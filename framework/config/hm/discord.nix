{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      discord
    ];
    
    persistence."/snap/home/${username}" = {
      directories = [
        ".config/discord"
      ];
    };
    
    # Prevent Discord from checking for new versions by itself
    file.".config/discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
}

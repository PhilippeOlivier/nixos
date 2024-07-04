{
  pkgs
, desktopEntriesDirectory
, username
, ...
}:

let
  desktopEntry = import ./desktop-entry.nix { desktopEntriesDirectory = desktopEntriesDirectory; };
in

{
  home = {
    packages = with pkgs; [
      discord
    ];

    # Prevent Discord from checking for new versions by itself
    file.".config/discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';

    persistence."/nosnap/home/${username}" = {
      directories = [
        ".config/discord"
      ];
    };
  };
  
  xdg.dataFile = desktopEntry {
    name = "Discord";
    exec = "discord";
  };
}

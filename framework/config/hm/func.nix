let
  desktopEntriesDirectory = "/home/pholi/.config/pholi-desktop-entries/applications";
in

{
  name
, exec
}:

{
  "${desktopEntriesDirectory}/${name}.desktop".text = ''
[Desktop Entry]
Type=Application
Name=${name}
Exec=${exec}
'';
}

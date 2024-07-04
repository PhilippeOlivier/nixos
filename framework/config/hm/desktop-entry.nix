# let
#   desktopEntriesDirectory = "/home/pholi/.config/pholi-desktop-entries";
# in

{desktopEntriesDirectory}:

{
  name
, exec
}:

{
  #"${desktopEntriesDirectory}/${name}.desktop".text = ''
  "${desktopEntriesDirectory}/${name}.desktop".text = ''
[Desktop Entry]
Type=Application
Name=${name}
Exec=${exec}
'';
}

# let
#   desktopEntriesDirectory = "/home/pholi/.config/pholi-desktop-entries";
# in

{dir}:

{
  name
, exec
}:

{
  #"${desktopEntriesDirectory}/${name}.desktop".text = ''
  "${dir}/${name}.desktop".text = ''
[Desktop Entry]
Type=Application
Name=${name}
Exec=${exec}
'';
}

{
  desktopEntriesDirectory
}:

{
  name
, exec
}:

{
  "${desktopEntriesDirectory}/${name}.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=${name}
#     Exec=${exec}
#   '';
}

# {
#   desktopEntriesDirectory
# }:

# {
#   name
# , exec
# }:

# {
#   "${desktopEntriesDirectory}/${name}.desktop".text = ''
#     [Desktop Entry]
#     Type=Application
#     Name=${name}
#     Exec=${exec}
#   '';
# }

{
  desktopEntriesDirectory
}:

{
  entries
}:

let
  generateEntry = entry:
    {
      "${desktopEntriesDirectory}/${entry.name}.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=${entry.name}
        Exec=${entry.exec}
      '';
    };
in
  map generateEntry entries

# {
#   a
# }:

# {
#    "/home/pholi/.config/desktop-test/applications/${a}.desktop".text = ''
# [Desktop Entry]
# Name=${a}
# Type=Application
# Exec=${a}
#     '';
# }



{
  username
}:

{
  {
    a
  }:

  {
    "/home/pholi/.config/desktop-test/applications/${a}.desktop".text = ''
[Desktop Entry]
Name=${a}
Type=Application
Exec=${a}
    '';
  };
}

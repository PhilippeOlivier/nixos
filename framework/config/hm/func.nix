{
  a,
  username,
  ...
}:

{
  "/home/${username}/.config/desktop-test/applications/${a}.desktop".text = ''
[Desktop Entry]
Name=${a}2
Type=Application
Exec=${a}
'';
}



# {
#   username
# }:

# {
#   myfunc = {
#     a
#   }:

#     {
#       "/home/pholi/.config/desktop-test/applications/${a}.desktop".text = ''
# [Desktop Entry]
# Name=${a}
# Type=Application
# Exec=${a}
#     '';
#     };
# }

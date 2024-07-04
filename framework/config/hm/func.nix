let
  dir = "/home/pholi/.config/pholi-desktop-entries/applications";
in

{
  a#,
 # dir
}:

{
  "${dir}/${a}.desktop".text = ''
[Desktop Entry]
Name=${a}4
Type=Application
Exec=${a}
'';
}

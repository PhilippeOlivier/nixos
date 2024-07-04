let
  dir = "/home/pholi";
in

{
  a,
  dir
}:

{
  "${dir}/${a}.desktop".text = ''
[Desktop Entry]
Name=${a}3
Type=Application
Exec=${a}
'';
}

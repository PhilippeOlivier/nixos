{
  homeDirectory
, ...
}:

{
  # not finished yet
  xdg = {
    enable = true;
    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
  };
}

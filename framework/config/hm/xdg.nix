{
  homeDirectory
, ...
}:

{
  xdg = {
    enable = true;
    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = "emacsclient.desktop";
        "application/postscript" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" "com.github.xournalpp.xournalpp.desktop" ];
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-shellscript" = "emacsclient.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";
        "image/bmp" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/jpg" = "imv.desktop";
        "image/png" = "imv.desktop";
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";
        "image/tiff" = "imv.desktop";
        "text/csv" = [ "emacsclient.desktop" "libreoffice-calc.desktop" ];
        "text/html" = [ "firefox.desktop" "emacsclient.desktop" ];
        "text/xhtml" = [ "firefox.desktop" "emacsclient.desktop" ];
        "text/markdown" = "emacsclient.desktop";
        "text/plain" = "emacsclient.desktop";
        "text/tab-separated-values" = "emacsclient.desktop";
        "text/x-bibtex" = "emacsclient.desktop";
        "text/x-c++src" = "emacsclient.desktop";
        "text/x-makefile" = "emacsclient.desktop";
        "text/x-tex" = "emacsclient.desktop";
        "video/x-matroska" = "mpv.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
    stateHome = "${homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      desktop = "${homeDirectory}/temp/xdg/desktop";
      documents = "${homeDirectory}/documents";
      download = "${homeDirectory}/downloads";
      music = "${homeDirectory}/music";
      pictures = "${homeDirectory}/pictures";
      publicShare = "${homeDirectory}/temp/xdg/public";
      templates = "${homeDirectory}/temp/xdg/templates";
      videos = "${homeDirectory}/temp/xdg/videos";
    };
  };
}

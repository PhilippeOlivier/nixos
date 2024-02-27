{
  xdg = {
    enable = true;
    cacheHome = "/home/pholi/.cache";
    configHome = "/home/pholi/.config";
    dataHome = "/home/pholi/.local/share";
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = "emacsclient.desktop";
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" "com.github.xournalpp.xournalpp.desktop" ];
        "application/postscript" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/x-shellscript" = "emacsclient.desktop";
        "image/bmp" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/gif" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/jpeg" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/jpg" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/png" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";
        "image/tiff" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "text/csv" = [ "emacsclient.desktop" "libreoffice-calc.desktop" ];
        "text/html" = [ "firefox.desktop" "emacsclient.desktop" ];
        "text/markdown" = "emacsclient.desktop";
        "text/plain" = "emacsclient.desktop";
        "text/tab-separated-values" = "emacsclient.desktop";
        "text/x-bibtex" = "emacsclient.desktop";
        "text/x-c++src" = "emacsclient.desktop";
        "text/x-makefile" = "emacsclient.desktop";
        "text/x-tex" = "emacsclient.desktop";
      };
    };
    stateHome = "/home/pholi/.local/state";
    userDirs = {
      enable = true;
      desktop = "/home/pholi/temp/xdg/desktop";
      documents = "/home/pholi/documents";
      download = "/home/pholi/downloads";
      music = "/home/pholi/music";
      pictures = "/home/pholi/pictures";
      publicShare = "/home/pholi/temp/xdg/public";
      templates = "/home/pholi/temp/xdg/templates";
      videos = "/home/pholi/temp/xdg/videos";
    };
  };
}

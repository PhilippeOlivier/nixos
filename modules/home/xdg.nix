{
  xdg = {
    enable = true;
    cacheHome = "/home/pholi/.cache";
    configHome = "/home/pholi/.config";
    dataHome = "/home/pholi/.local/share";
    mimeApps = {
      enable = false;
      defaultApplications = {
        "application/json" = "emacs.desktop";
        "application/pdf" = [ "zathura.desktop" "com.github.xournalpp.xournalpp.desktop" ];
        "application/postscript" = "zathura.desktop";
        "application/x-shellscript" = "emacs.desktop";
        "image/bmp" = "zathura.desktop";
        "image/gif" = "zathura.desktop";
        "image/jpeg" = "zathura.desktop";
        "image/jpg" = "zathura.desktop";
        "image/png" = "zathura.desktop";
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";
        "image/tiff" = "zathura.desktop";
        "text/csv" = [ "emacs.desktop" "libreoffice-calc.desktop" ];
        "text/html" = [ "firefox.desktop" "emacs.desktop" ];
        "text/markdown" = "emacs.desktop";
        "text/plain" = "emacs.desktop";
        "text/tab-separated-values" = "emacs.desktop";
        "text/x-bibtex" = "emacs.desktop";
        "text/x-c++src" = "emacs.desktop";
        "text/x-makefile" = "emacs.desktop";
        "text/x-tex" = "emacs.desktop";
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

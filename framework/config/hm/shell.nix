{
  pkgs
, username
, ...
}:

{
  home = {
    packages = with pkgs; [
      # Tools
      coreutils
      curl
      dos2unix
      ffmpeg
      fzf
      imagemagick
      pdfgrep
      rsync
      tree
      wget
      yt-dlp

      # Filesystem
      exfatprogs
      hfsprogs
      ntfs3g
      parted

      # Compression
      bzip2
      bzip3
      gzip
      lrzip
      lz4
      lzip
      lzop
      p7zip
      rar
      # unrar
      unzip
      xz
      zip
      zstd

      # PDF
      diffpdf
      qpdf
      
      # Utilities
      htop
    ];

    sessionVariables = {
      BROWSER = "${pkgs.firefox}/bin/firefox";
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "${pkgs.emacs}/bin/emacs";
      VISUAL = "${pkgs.emacs}/bin/emacs";
    };

    shellAliases = {
      grip = ''grip --pass $(pass show github.com/token)'';  # Use my GitHub token to avoid the hourly rate limit
      ls = "ls --color=auto";  # Colorize the `ls` command
      # opto = "cd /home/pholi/.nixos-extra/scripts/emma/opto/ && nix-shell --command 'python opto.py'";  # Run the wife's opto script
      reboot = "${pkgs.emacs}/bin/emacsclient -e '(save-some-buffers t)' && reboot";  # Save all Emacs buffers before rebooting
    };
    
    persistence."/snap/home/${username}" = {
      files = [
        ".bash_history"
      ];
      directories = [
        ".local/share/direnv"
      ];
    };
  };
  
  programs = {
    bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignoredups"
        "ignorespace"
      ];
      initExtra = ''PS1="[\u@\h \W]\$ "'';
    };
    
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}

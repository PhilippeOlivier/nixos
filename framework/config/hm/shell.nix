{
  pkgs
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
      unrar
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

    persistence."/snap/home/${username}" = {
      directories = [
        ".bash_history"
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

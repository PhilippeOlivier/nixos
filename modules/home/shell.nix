{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # Tools
      bc
      coreutils
      curl
      dos2unix
      expect
      fzf
      imagemagick
      inotify-tools
      jq
      pdfgrep
      rsync
      tmux
      tree
      udisks
      vim
      wget
      ydotool
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
      
      # Utilities
      htop
    ];

    file.".bash_history".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/shell/bash_history";
  };
  
  programs.bash = {
    enable = true;
    historyControl = [
      "erasedups"
      "ignoredups"
      "ignorespace"
    ];
    initExtra = ''PS1="[\u@\h \W]\$ "'';
    bashrcExtra = "source /home/pholi/.nixos-extra/scripts/pholi/pholi.sh";
  };
}

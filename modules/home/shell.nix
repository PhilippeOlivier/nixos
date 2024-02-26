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
      unrar
      unzip
      zip
      
      # Utilities
      htop
    ];
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

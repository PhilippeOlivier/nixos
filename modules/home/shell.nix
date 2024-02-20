{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      bc
      coreutils
      jq
      tree
      unrar
      unzip
      wget
      zip
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
    bashrcExtra = "source /home/pholi/.nixos-extra/scripts/pholi/pholi.sh"
  };
}

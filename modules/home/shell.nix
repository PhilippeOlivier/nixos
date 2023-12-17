{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      bc
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
  };
}

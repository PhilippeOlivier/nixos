{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      tree
      wget
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

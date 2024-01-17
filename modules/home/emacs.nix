{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      emacs
    ];
    file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/emacs";
  };
}

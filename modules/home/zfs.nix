{ config, pkgs, ... }:

{
  # Symlinks for the `~/.snap` directory
  home = {
    file.".nixos-extra".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.zsnap/.nixos-extra";
    file."syncthing".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.zsnap/syncthing";
  };
}

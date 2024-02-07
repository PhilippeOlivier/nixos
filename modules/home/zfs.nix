{ config, pkgs, ... }:

{
  # Symlinks for the `~/.zsnap` directory
  # home = {
  #   file.".nixos-extra".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.zsnap/.nixos-extra";
  #   file."documents".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.zsnap/documents";
  #   file."syncthing".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.zsnap/syncthing";
  # };
}

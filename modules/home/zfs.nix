{ config, pkgs, ... }:

{
  # Symlinks for all directories that won't be snapshotted by ZFS
  home = {
    file.".cache".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/cache";
    file.".config".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/config";
    file.".local".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/local";
    file."downloads".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/downloads";
    file."syncthing".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/syncthing";
    file."temp".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/temp";
    file."torrents".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/torrents";
  };
}

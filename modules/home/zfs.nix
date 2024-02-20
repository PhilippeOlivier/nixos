{ config, pkgs, ... }:

{
  # Symlinks for all directories that won't be snapshotted by ZFS
  home = {
    file."downloads".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/downloads";
    file."syncthing".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/syncthing";
    file."temp".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/temp";
    file."torrents".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/torrents";

    # Required for ZFS backups
    packages = with pkgs; [
      lz4
      sanoid
    ];
  };
}

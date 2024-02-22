{ config, pkgs, ... }:

{
  # Symlinks for all directories that won't be snapshotted by ZFS
  home = {
    file.".cache".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.cache";
    file.".cargo".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.cargo";
    # file.".config".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.config";
    file.".dotnet".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.dotnet";
    file.".local".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.local";
    file.".mypy_cache".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.mypy_cache";
    file.".npm".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.npm";
    file.".wine".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/.wine";
    file."downloads".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/downloads";
    file."syncthing".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/syncthing";
    file."temp".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/temp";
    file."torrents".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nosnap/torrents";
  };
}

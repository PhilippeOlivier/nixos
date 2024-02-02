{ config, pkgs, ... }:

{
  # home = {
  #   packages = with pkgs; [
  #     firefox
  #   ];
  #   file.".mozilla".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/mozilla";

  programs.chromium = {
    enable = true;
    extensions = [
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";  # uBlock Origin
      }
    ];
  };
}

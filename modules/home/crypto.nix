{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      gnupg
      openssh
      pass
    ];
    file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/gnupg";
    file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/ssh";
    file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/password-store";
  };
}

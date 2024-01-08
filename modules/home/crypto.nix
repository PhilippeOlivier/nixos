{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      gnupg
      gpg-agent
      openssh
      pass
      pinentry
      ssh-agent
    ];
    file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/gnupg";
    file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/ssh";
    file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/password-store";
  };

  # services = {
  #   gpg-agent = {
  #     enable = true;
  #     defaultCacheTtl = 8640000;
  #     maxCacheTtl = 8640000;
  #     pinentryFlavor = "curses";  # TODO: gtk2?
  #   };
  #   ssh-agent = {
  #     enable = true;
  #   };
  # };
}

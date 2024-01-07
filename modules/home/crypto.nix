{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };
  
  home.file.".gnupg" = {
    # source = config.lib.file.mkOutOfStoreSymlink ../../../.nixos-extra/gnupg;
    source = /home/pholi/.nixos-extra/gnupg;
    recursive = true;
  };

  # services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 8640000;
  #   maxCacheTtl = 8640000;
  #   pinentryFlavor = "curses";  # TODO: gtk2?
  # };

  # programs.password-store = {
  #   enable = true;
  # };

  # home.file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/password-store";

  # programs.ssh = {
  #   enable = true;
  # };

  # home.file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/ssh";
  
  # services.ssh-agent.enable = true;
}

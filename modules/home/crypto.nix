{ config, pkgs, ... }:

{
  # programs.gpg = {
  #   enable = true;
  # };
  
  # home.file.".gnupg" = {
  #   # source = ./.nixos
  #   source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/gnupg";
  #   # source = ./../../../.nixos-extra/gnupg;  no because absolute path
  #   # source = ./.nixos-extra/gnupg;  no because relative to crypto.nix
  #   # source = /home/pholi/.nixos-extra/gnupg; forbidden in pure eval
  #   recursive = true;
  # };

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

  programs.ssh = {
    enable = true;
  };

  home.file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/ssh";
  
  # services.ssh-agent.enable = true;
}

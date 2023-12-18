{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    homedir = "/home/pholi/nixos/secrets/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 8640000;
    maxCacheTtl = 8640000;
    pinentryFlavor = "gtk2";
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "/home/pholi/nixos/secrets/password-store";
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = "";
  };
}

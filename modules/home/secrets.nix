{ config, pkgs, ... }:

{
  
  
  programs.gpg = {
    enable = true;
    homedir = "/home/pholi/nixos/secrets/gnupg";
  };

  programs.gnupg.agent = {
    enable = true;
  };
  
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 8640000;
    maxCacheTtl = 8640000;
    pinentryFlavor = "gtk2";
  };
}

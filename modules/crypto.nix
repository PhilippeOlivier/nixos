{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AuthenticationMethods = "publickey";
      PrintMotd = false;
    };
  };

  environment.systemPackages = [
    pkgs.cryptsetup
    pkgs.pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 8640000;
      max-cache-ttl = 8640000;
    };
    pinentryFlavor = "qt";
  };

  security.pam.services.swaylock = {};  # Required for swaylock to work
}

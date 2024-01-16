{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;  # TODO: false
      KbdInteractiveAuthentication = true; # TODO: false
      PermitRootLogin = "no";
      # AuthenticationMethods = "publickey";  <-- uncomment
      PrintMotd = false;
    };
  };

  environment.systemPackages = [
    pkgs.pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 8640000;
      max-cache-ttl = 8640000;
    };
    #pinentryFlavor = "curses";
  };
}

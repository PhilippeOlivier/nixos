{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;  # TODO: false
      KbdInteractiveAuthentication = true; # TODO: false
      PermitRootLogin = false;
      # AuthenticationMethods = "publickey";  <-- uncomment
      PrintMotd = false;
    };
  };
}

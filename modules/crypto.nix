{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = true; # false;
      KbdInteractiveAuthentication = true; #false;
      #PermitRootLogin = "yes";
    };
  };
}

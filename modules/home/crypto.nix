{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      gnupg
      openssh
      pass
      pinentry
    ];
    file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/gnupg";
    file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/ssh";
    file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/.nixos-extra/password-store";
  };

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };
}

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
    pinentryFlavor = "curses"; # gtk2?
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

  services.ssh-agent.enable = true;

  # services.openssh = {
  #   enable = true;
  #   # require public key authentication for better security
  #   settings.PasswordAuthentication = false;
  #   settings.KbdInteractiveAuthentication = false;
  #   #settings.PermitRootLogin = "yes";
  # };

  # users.users.pholi.openssh.authorizedKeys.keyFiles = [
  #   /home/pholi/nixos/secrets/ssh/authorized_keys
  # ];

  home = {
    packages = with pkgs; [
      openssh
      sops
    ];
  };

  # home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/nixos/secrets/ssh/config";
  # home.file.".ssh/id_25519".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/nixos/secrets/ssh/id_25519";
  # home.file.".ssh/id_25519.pub".source = config.lib.file.mkOutOfStoreSymlink "/home/pholi/nixos/secrets/ssh/id_25519.pub";
  # another symlink for authorized keys


}

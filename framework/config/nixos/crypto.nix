{
  pkgs
, username
, ...
}:

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

  environment.systemPackages = with pkgs; [
    cryptsetup
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    sops
  ];

  # This also includes `gnupg`
  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 8640000;
      max-cache-ttl = 8640000;
    };
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  environment.persistence."/snap" = {
    directories = [
      "/etc/ssh"
    ];
    users.${username} = {
      directories = [
        ".gnupg"
        ".password-store"
        ".ssh"
      ];
    };
  };
  sops = {
    age.keyFile = "/home/pholi/nixos/framework/extra/sops/age-key.txt";
  };
}

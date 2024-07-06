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
    gnupg
    openssh
    (pass.withExtensions (ext: with ext; [ pass-otp ]))
    pinentry
  ];

  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 8640000;
      max-cache-ttl = 8640000;
    };
    pinentryPackage = pkgs.pinentry-qt;
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
}

{
  pkgs
, sopsAgeKeyFilePath
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

  # This also includes `gnupg`
  programs.gnupg.agent = {
    enable = true;
    settings = {
      default-cache-ttl = 8640000;
      max-cache-ttl = 8640000;
    };
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  sops = {
    age.keyFile = sopsAgeKeyFilePath;
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
  
  environment.persistence."/snap" = {
    directories = [
      "/etc/ssh"
    ];

    users.${username} = {
      directories = [
        ".sops"
      ];
    };
  };
}

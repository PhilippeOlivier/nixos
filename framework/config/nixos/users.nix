{
  pkgs
, homeDirectory
, username
, ...
}:

{
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$G0Y8DMYeCovADHuKDb73a1$KqGTktIZlpdjEH4yubPnVTpZywk2Zf6fbk979YvKPk3";
  };
  
  users.users.${username} = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$/agu8wY6h/PB20gbxj6aC.$JEuBPcl7F5crecpUFQ3SH.cEsNjMYD.8JnHArimSAt/";
    description = "Philippe Olivier";
    home = homeDirectory;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
    ];
  };

  # Auto-login (this is okay since the disk has to be decrypted manually beforehand)
  services.getty.autologinUser = username;

  # This is required to run many scripts correctly
  security.sudo = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}

{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$G0Y8DMYeCovADHuKDb73a1$KqGTktIZlpdjEH4yubPnVTpZywk2Zf6fbk979YvKPk3";
  };
  
  users.users.steamlink = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$/agu8wY6h/PB20gbxj6aC.$JEuBPcl7F5crecpUFQ3SH.cEsNjMYD.8JnHArimSAt/";
    description = "steamlink";
    home = "/home/steamlink";
    extraGroups = [
      "wheel"
    ];
  };
}

{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  users.users.root = {
    isSystemUser = true;
    hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3"; # asdf
    # hashedPassword = "$y$j9T$G0Y8DMYeCovADHuKDb73a1$KqGTktIZlpdjEH4yubPnVTpZywk2Zf6fbk979YvKPk3";
  };
  
  users.users.pholi = {
    isNormalUser = true;
    # hashedPassword = "$y$j9T$x96MzdskuJld7.MGfXLpE1$cOerhhSRfrLWEgyOI6vNmcRDnHshQ0e1QVDL3CMEFy3"; # asdf
    password = "asdf";
    # hashedPassword = "$y$j9T$/agu8wY6h/PB20gbxj6aC.$JEuBPcl7F5crecpUFQ3SH.cEsNjMYD.8JnHArimSAt/";
    description = "Philippe Olivier";
    home = "/home/pholi";
    # shell = pkgs.bash;
    extraGroups = [
      "docker"
      "wheel"
    ];
  };
}

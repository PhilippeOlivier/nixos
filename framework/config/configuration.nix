{
  stateVersion
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos
  ];
  
  system.stateVersion = stateVersion;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.mystring = { };
    age.keyFile = "/snap/home/pholi/.sops/framework-age-key.txt";
  };
}

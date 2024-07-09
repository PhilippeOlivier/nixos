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

  sops.age.keyFile = "/snap/home/pholi/nixos/framework/extra/sops/age-key.txt";
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.mystring = { };
}

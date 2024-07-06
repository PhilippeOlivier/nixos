{
  stateVersion
, ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos
  ];

  sops.defaultSopsFile = secrets/example.yaml;
  
  system.stateVersion = stateVersion;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;
}

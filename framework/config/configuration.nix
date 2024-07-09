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
}

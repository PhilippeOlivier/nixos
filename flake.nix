{
  description = "pholi nixos system";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.pholi-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix
      ];
    };
  };
}

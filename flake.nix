{
  description = "pholi nixos system";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, sops-nix, ... }: {
    nixosConfigurations.pholi-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.pholi = import ./modules/home.nix;
        }
        sops-nix.homeManagerModules.sops
        #sops-nix.nixosModules.sops
        # sops-nix/modules/home-manager/sops.nix
      ];
    };
  };
}

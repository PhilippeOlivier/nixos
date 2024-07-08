{
  description = "pholi NixOS configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ { self, home-manager, impermanence, nixpkgs, sops-nix, ... }: # TODO TEMP sops-nix
    let
      homeDirectory = "/home/${username}";
      hostId = "cafe0000";
      hostName = "pholi-nixos";
      localIp = "192.168.100.100";
      stateVersion = "24.05";
      system = "x86_64-linux";
      username = "pholi";
      wirelessDevice = "wlp4s0";  # `ip link`
    in
      {
        nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              homeDirectory
              hostId
              hostName
              localIp
              stateVersion
              system
              username
              wirelessDevice
            ;
          };
          system = system;
          modules = [
            ./configuration.nix
            impermanence.nixosModule
            sops-nix.nixosModules.sops  # TODO TEMP sops nix
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit
                  homeDirectory
                  stateVersion
                  username
                  wirelessDevice
                ;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username}.imports = [
                ./hm.nix
                (inputs.impermanence + "/home-manager.nix")
                # inputs.sops-nix.homeManagerModules.sops  # TODO TEMP removed HM
              ];
            }
          ];
        };
      };
}

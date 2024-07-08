{
  description = "pholi NixOS configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ { self, home-manager, impermanence, nixpkgs, ... }:
    let
      desktopEntriesDirectory = "${homeDirectory}/.config/pholi-desktop-entries";
      homeDirectory = "/home/${username}";
      hostId = "cafe0000";
      hostName = "pholi-nixos";
      keyboardDevice = "1:1:AT_Translated_Set_2_keyboard";  # `swaymsg -t get_inputs`
      localIp = "192.168.100.100";
      outputDevice = "eDP-1";  # `swaymsg -t get_outputs`
      outputFreq = "60.008";  # `swaymsg -t get_outputs`
      outputHeight = "1080";  # `swaymsg -t get_outputs`
      outputScale = "1.0";
      outputWidth = "1920";  # `swaymsg -t get_outputs`
      outputDeviceLeft = "DP-4";  # `swaymsg -t get_outputs`
      outputFreqLeft = "60.000";  # `swaymsg -t get_outputs`
      outputHeightLeft = "1080";  # `swaymsg -t get_outputs`
      outputScaleLeft = "1.0";
      outputWidthLeft = "1920";  # `swaymsg -t get_outputs`
      outputDeviceRight = "DP-2";  # `swaymsg -t get_outputs`
      outputFreqRight = "60.000";  # `swaymsg -t get_outputs`
      outputHeightRight = "1080";  # `swaymsg -t get_outputs`
      outputScaleRight = "1.0";
      outputWidthRight = "1920";  # `swaymsg -t get_outputs`
      screenshotDirectory = ".config/pholi-screenshots";
      signalBattery = "12";
      signalBrightness = "11";
      signalKeyboard = "14";
      signalMail = "16";
      signalNetwork = "15";
      signalVolume = "13";
      stateVersion = "24.05";
      system = "x86_64-linux";
      touchpadDevice = "2:7:SynPS/2_Synaptics_TouchPad";  # `swaymsg -t get_inputs`
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
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit
                  desktopEntriesDirectory
                  homeDirectory
                  keyboardDevice
                  outputDevice
                  outputFreq
                  outputHeight
                  outputScale
                  outputWidth
                  outputDeviceLeft
                  outputFreqLeft
                  outputHeightLeft
                  outputScaleLeft
                  outputWidthLeft
                  outputDeviceRight
                  outputFreqRight
                  outputHeightRight
                  outputScaleRight
                  outputWidthRight
                  screenshotDirectory
                  signalBattery
                  signalBrightness
                  signalKeyboard
                  signalMail
                  signalNetwork
                  signalVolume
                  stateVersion
                  touchpadDevice
                  username
                  wirelessDevice
                ;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username}.imports = [
                ./hm
                (inputs.impermanence + "/home-manager.nix")
                inputs.sops-nix.homeManagerModule #s.sops
              ];
            }
          ];
        };
      };
}

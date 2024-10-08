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

  outputs = inputs @ { self, home-manager, impermanence, sops-nix, nixpkgs, ... }:
    let
      desktopEntriesDirectory = "${homeDirectory}/.config/pholi-desktop-entries";
      email1 = "imper@pedtsr.ca";
      emails = "${email1}";
      eyepatchDirectory = ".config/eyepatch";
      hnDirectory = ".config/hn";
      homeDirectory = "/home/${username}";
      hostId = "cafe0000";
      hostName = "pholi-nixos";
      keyboardDevice = "1:1:AT_Translated_Set_2_keyboard";  # `swaymsg -t get_inputs`
      localIp = "192.168.100.100";
      maildirsDirectory = ".maildirs";
      maildirsPath = "${homeDirectory}/${maildirsDirectory}";
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
      pholiScriptDirectory = ".config/pholi-script";
      screenshotDirectory = "screenshots";
      screenshotPath = "${homeDirectory}/${screenshotDirectory}";
      secretsFilePath = "${homeDirectory}/nixos/framework/config/secrets/secrets.yaml";
      signalBattery = "12";
      signalBrightness = "11";
      signalKeyboard = "14";
      signalMail = "16";
      signalNetwork = "15";
      signalVolume = "13";
      sopsAgeKeyFilePath = "/snap${homeDirectory}/${sopsDirectory}/framework-age-key.txt";  # This must be the full path to the persisted directory (because of impermanence+sops)
      sopsDirectory = ".config/sops";
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
              sopsAgeKeyFilePath
              sopsDirectory
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
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = {
                inherit
                  desktopEntriesDirectory
                  email1
                  emails
                  eyepatchDirectory
                  hnDirectory
                  homeDirectory
                  keyboardDevice
                  maildirsDirectory
                  maildirsPath
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
                  pholiScriptDirectory
                  screenshotDirectory
                  screenshotPath
                  secretsFilePath
                  signalBattery
                  signalBrightness
                  signalKeyboard
                  signalMail
                  signalNetwork
                  signalVolume
                  sopsAgeKeyFilePath
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
                inputs.sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };
      };
}

{
  pkgs
, ...
}:

{
  imports = [
    ./android.nix
    ./bluetooth.nix
    ./boot.nix
    ./docker.nix
    ./fonts.nix
    #./framework.nix
    ./impermanence.nix
    ./mullvad.nix
    ./network.nix
    ./system.nix
    ./thunar.nix
    ./users.nix
    ./zfs.nix
  ];

# TEMP: WiFi
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";

  security.polkit.enable = true;  # Required for sway with HM
  security.pam.services.swaylock = {};  # Required for swaylock to work
}

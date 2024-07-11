{
  config
, pkgs
, ...
}:

{
  imports = [
    ./android.nix
    ./bluetooth.nix
    ./boot.nix
    ./crypto.nix
    ./docker.nix
    ./fonts.nix
    #./framework.nix
    ./impermanence.nix
    ./mullvad.nix
    ./network.nix
    ./secrets.nix
    ./sway.nix
    ./system.nix
    ./thunar.nix
    ./users.nix
    ./zfs.nix
  ];

  # TEMP: WiFi
  #networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";


  sops.secrets."wireless" = { };
  networking.wireless.environmentFile = config.sops.secrets."wireless".path;
  networking.wireless.networks = { "@home_uuid@" = { psk = "@home_psk@"; }; };


  # networking.wireless.environmentFile = config.sops.secrets."wireless.env".path;
  # networking.wireless.networks = { "@home_uuid@" = { psk = "@home_psk@"; }; };
}

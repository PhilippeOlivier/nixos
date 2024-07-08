{
  config  # TODO: temp
, pkgs
, ...
}:

let
  testScript = pkgs.writeShellScript "test-script-1.sh" ''
    echo "This is the SOPS test script"
    echo "asdfasdf"
  '';

in

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
    ./sway.nix
    ./system.nix
    ./thunar.nix
    ./users.nix
    ./zfs.nix
  ];

  # TEMP: WiFi
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";

  # sops.defaultSopsFile = ../secrets/example.yaml;  # <-- the problem is the file is not in git
  # sops.secrets."wireless.env" = { };
  # networking.wireless.environmentFile = config.sops.secrets."wireless.env".path;
  # networking.wireless.networks = { "@home_uuid@" = { psk = "@home_psk@"; }; };
}

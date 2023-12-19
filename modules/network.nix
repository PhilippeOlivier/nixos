{ config, pkgs, ... }:

{
  networking = {
    hostName = "pholi-nixos";

    # Use wpa_supplicant
    wireless.enable = true;

    # DHCP (set to false because it is deprecated)
    useDHCP = false;

    # We must set all interfaces individually
    interfaces.wlp4s0.useDHCP = true;
    interfaces.enp0s31f6.useDHCP = true;
  };


  
  # WiFi networks
  #networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
  # TODO: Other networks
}

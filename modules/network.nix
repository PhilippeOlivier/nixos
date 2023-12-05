{ config, pkgs, ... }:

{
  # Hostname
  networking.hostName = "pholi-nixos";

  # Use wpa_supplicant
  networking.wireless.enable = true;

  # DHCP
  networking.useDHCP = false;  # Set to false because it is deprecated

  # We must set all interfaces individually
  networking.interfaces.wlp4s0.useDHCP = true;
  # TODO: Ethernet
  
  # WiFi networks
  networking.wireless.networks.AwesomenautsEXT.pskRaw = "6521e88582fdc0fda473fa548375627950a87185610768bed19eb41005409161";
  # TODO: Other networks
}

{
  networking = {
    hostName = "pholi-nixos";

    # Use wpa_supplicant
    wireless.enable = true;

    # DHCP (set to false because it is deprecated)
    useDHCP = false;

    # Set all interfaces individually
    interfaces.wlp4s0.useDHCP = true;
    interfaces.enp0s31f6.useDHCP = true;
  };
}

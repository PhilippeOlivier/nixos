{
  networking = {
    hostName = "pholi-nixos";

    # Use wpa_supplicant
    wireless.enable = true;

    # DHCP (set to false because it is deprecated)
    useDHCP = false;

    # Set all interfaces individually
    interfaces = {
      wlp4s0 = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.0.81";
            prefixLength = 24;
          }
        ];
      };
      enp0s31f6 = {
        useDHCP = true;
      };
    };

    # Firewall
    nftables.enable = true;  # Use the newer nftables instead of the older iptables
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8384   # Syncthing
        22000  # Syncthing
      ];
      allowedUDPPorts = [
        22000  # Syncthing
        21027  # Syncthing
      ];
    };
  };
}

{
  networking = {
    hostName = "pholi-nixos";

    # Use wpa_supplicant
    wireless.enable = true;

    # DHCP (set to false because it is deprecated)
    useDHCP = false;

    # Set all interfaces individually
    interfaces = {
      wlp166s0 = {
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "192.168.0.81";
            prefixLength = 24;
          }
        ];
      };
      # enp0s31f6 = {
      #   useDHCP = true;
      # };
    };

    # systemd-resolved
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

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

  services = {
    # systemd-resolved
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
    mullvad-vpn.enable = true;
  };
}

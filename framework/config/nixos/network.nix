{
  hostName
, localIp
, wirelessDevice
, ...
}:

{
  networking = {
    hostName = hostName;

    # Use wpa_supplicant
    wireless = {
      enable = true;
      userControlled.enable = true;  # Allow the use of `wpa_gui`
    };

    # # Network interfaces
    # interfaces = {
    #   ${wirelessDevice} = {
    #     useDHCP = true;
    #     ipv4.addresses = [
    #       {
    #         address = localIp;
    #         prefixLength = 24;
    #       }
    #     ];
    #   };
    # };

    # systemd-resolved
    nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

    # Firewall
    nftables.enable = true;  # Use the newer nftables instead of the older iptables
    firewall = {
      enable = true;
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
  };
}

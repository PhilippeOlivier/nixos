{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.gutenprint
      pkgs.gutenprintBin
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

# cups?
  
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-3170CDW";
        location = "Home";
        deviceUri = "dnssd://Brother%20HL-3170CDW%20series._printer._tcp.local/?uuid=e3248000-80ce-11db-8000-30055ca8972a";
        model = "Brother_HL-3170CDW_series.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Brother_HL-3170CDW";
  };
}

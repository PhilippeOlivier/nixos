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
    nssmdns = true;
    openFirewall = true;
  };

  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "HL-3170CDW";
  #       location = "Home";
  #       deviceUri = "http://192.168.178.2:631/printers/Dell_1250c";
  #       model = "drv:///sample.drv/generic.ppd";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  #   ensureDefaultPrinter = "HL-3170CDW";
  # };
}

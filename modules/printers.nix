{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.gutenprint
      pkgs.gutenprintBin
      pkgs.linkFarm "Brother_HL-3170CDW_series" [{
        name = "share/cups/model/hl3170cdw.ppd";
        path = "Brother_HL-3170CDW_series.ppd";
      }]
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # cups?
  # do this: https://github.com/balsoft/nixos-config/blob/master/flake.nix
# THIS:https://github.com/balsoft/nixos-config/blob/73cc2c3a8bb62a9c3980a16ae70b2e97af6e1abd/profiles/workspace/print-scan/default.nix#L4
  
  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "Brother_HL-3170CDW";
  #       location = "Home";
  #       deviceUri = "dnssd://Brother%20HL-3170CDW%20series._printer._tcp.local/?uuid=e3248000-80ce-11db-8000-30055ca8972a";
  #       model = "Brother_HL-3170CDW_series.ppd";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  #   ensureDefaultPrinter = "Brother_HL-3170CDW";
  # };
}

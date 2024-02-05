{ config, pkgs, ... }:

# See: https://github.com/balsoft/nixos-config/blob/master/profiles/workspace/print-scan/default.nix
# let
#   brother_printer = pkgs.linkFarm "Brother_HL-3170CDW_series" [{
#     name = "share/cups/model/hl3170cdw.ppd";
#     path = "Brother_HL-3170CDW_series.ppd";
#   }];
# in

{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brlaser
      pkgs.gutenprint
      pkgs.gutenprintBin
      # brother_printer
    ];
    # cups-pdf.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}

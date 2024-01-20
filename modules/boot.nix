{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  # Choose custom kernel version
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_latest;  # pkgs.linuxKernel.packages.linux_6_5
}

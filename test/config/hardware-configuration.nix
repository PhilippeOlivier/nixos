{
  lib
, pkgs
, modulesPath
# , hostId
# , system
, ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  networking.hostId = "cafe0000";  # hostId;
  nixpkgs.hostPlatform = "x86_64-linux";  # lib.mkDefault system;
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/CRYPTROOT";

  fileSystems."/" = {
    device = "tank/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/BOOT";
    fsType = "vfat";
  };

  fileSystems."/nix" ={
    device = "tank/nix";
    fsType = "zfs";
  };

  fileSystems."/snap" = {
    device = "tank/snap";
    fsType = "zfs";
    options = [
      "bind"
    ];
    neededForBoot = true;
  };
  
  fileSystems."/nosnap" = {
    device = "tank/nosnap";
    fsType = "zfs";
    neededForBoot = true;
  };
}

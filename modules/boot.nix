{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  # Choose custom kernel version
  # Source: https://discourse.nixos.org/t/override-kernel-version/3638/5
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_4_19.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
        sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
      };
      version = "4.19.60";
      modDirVersion = "${version}";
    };
  });
}

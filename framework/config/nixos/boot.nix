{
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };
}

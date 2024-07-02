{
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  environment.persistence."/snap" = {
    directories = [
      "/var/lib/bluetooth"
    ];
  };
}

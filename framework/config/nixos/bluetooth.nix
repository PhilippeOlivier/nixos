{
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  services.blueman.enable = true;
  
  # environment.persistence."/persist" = {
  #   directories = [
  #     "/var/lib/bluetooth"
  #   ];
  # };
}

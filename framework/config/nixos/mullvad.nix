{
  services.mullvad-vpn.enable = true;

  environment.persistence."/snap" = {
    directories = [
      "/etc/mullvad-vpn"
    ];
  };
}

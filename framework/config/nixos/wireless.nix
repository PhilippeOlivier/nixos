{
  config
, ...
}:

{
  sops.secrets."wireless" = {};

  networking.wireless = {
    environmentFile = config.sops.secrets."wireless".path;
    networks = {
      "@home_ssid@".psk = "@home_psk@";
    };
  };
}

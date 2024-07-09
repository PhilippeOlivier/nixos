{
  sopsAgeKeyFilePath
, ...
}:

{
  sops = {
    age.keyFile = sopsAgeKeyFilePath;
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets.mystring = {};
  };
}

{
  sopsAgeKeyFilePath
# , sops-nix
, ...
}:

{
  sops = {
    age.keyFile = sopsAgeKeyFilePath;
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets.mystring = {};

    # Secrets will always be in that path
    # Source: https://haseebmajid.dev/posts/2024-01-28-how-to-get-sops-nix-working-with-home-manager-modules
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };
}

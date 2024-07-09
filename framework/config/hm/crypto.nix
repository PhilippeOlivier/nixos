{
  config
, pkgs
, extraDirectory
, ...
}:

let
  # This must be the full path to the persisted directory (because of impermanence+sops)
  sopsAgeKeyFilePath = "/snap${extraDirectory}/sops/age-key.txt";
in

{
  sops = {
    age.keyFile = sopsAgeKeyFilePath;
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Secrets will always be in that path
    # Source: https://haseebmajid.dev/posts/2024-01-28-how-to-get-sops-nix-working-with-home-manager-modules
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  home = {
    packages = with pkgs; [
      cryptsetup
      (pass.withExtensions (ext: with ext; [ pass-otp ]))
      sops
    ];
    
    sessionVariables.SOPS_AGE_KEY_FILE = sopsAgeKeyFilePath;
    
    file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "${extraDirectory}/gnupg";
    file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "${extraDirectory}/password-store";
    file.".ssh".source = config.lib.file.mkOutOfStoreSymlink "${extraDirectory}/ssh";
  };
}

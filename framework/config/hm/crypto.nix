{
  pkgs
, homeDirectory
, sopsAgeKeyFilePath
, username
, ...
}:

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

    persistence."/snap/home/${username}" = {
      directories = [
        ".gnupg"
        ".password-store"
        # ".sops"  # This is already persisted in `nixos/crypto.nix`
        ".ssh"
      ];
    };
  };
}

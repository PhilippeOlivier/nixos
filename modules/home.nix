{ config, pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/shell.nix
    ./home/secrets.nix
    ./home/xdg.nix
  ];

  home = {
    # imports = [
    #   <sops-nix.homeManagerModules.sops>
    # ];
    stateVersion = "24.05";
    username = "pholi";
    homeDirectory = "/home/pholi";
  };

  sops = {
    #age.keyFile = "/home/user/.age-key.txt"; # must have no password!
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    defaultSopsFile = /home/pholi/nixos/secrets.yaml;
    secrets.test = {
      # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

      # %r gets replaced with a runtime directory, use %% to specify a '%'
      # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
      # DARWIN_USER_TEMP_DIR) on darwin.
      path = "%r/test.txt"; 
    };
  };

  programs.home-manager.enable = true;
}

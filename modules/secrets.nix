# { config, pkgs, ... }:

# {
#   sops.defaultSopsFile = ./secrets/test.yaml;
#   # # YAML is the default 
#   sops.defaultSopsFormat = "yaml";

#   # sops.secrets."ssh_key".mode = "0400";
#   # sops.secrets.ssh_key = {
#   #   format = "yaml";
#   #   # can be also set per secret
#   #   sopsFile = ./secrets/test.yaml;
#   # };
# }

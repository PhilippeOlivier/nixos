{ pkgs, config, ... }:

let
  secret = config.sops.secrets.mystring.path;
in

pkgs.writeShellScriptBin "hello-world" ''
  echo "Hello World $(cat ${secret})";
''

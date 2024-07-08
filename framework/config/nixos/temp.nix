let
  pkgs = import <nixpkgs> {};
  myScript = pkgs.writeShellScript "test-script-1.sh" ''
    #!/bin/sh
    echo "This is the SOPS test script"
    echo "asdfasdf"
  '';
in
pkgs.stdenv.mkDerivation {
  name = "my-script";
  src = myScript;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    chmod +x $out/bin/my-script
  '';
}

with import <nixpkgs> {};

let

  jenkins-script = pkgs.writeScriptBin "jenkins" ''
    #!${pkgs.stdenv.shell}
    echo asdf
  '';
in

pkgs.symlinkJoin {
  name = "jenkins-script-0.0.1";
  paths = [
    jenkins-script
  ];
}

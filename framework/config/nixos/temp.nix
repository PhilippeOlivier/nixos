{
pkgs
}:
pkgs.writeShellScript "test-script-1.sh" ''
    echo "This is the SOPS test script"
    echo "asdfasdf"
  ''

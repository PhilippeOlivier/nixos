{ config, pkgs, ... }:

{
  let
    my-python-packages = ps: with ps; [
      matplotlib
      pandas
    ];
  in
    environment.systemPackages = [
      (pkgs.python3.withPackages my-python-packages)
    ];
}

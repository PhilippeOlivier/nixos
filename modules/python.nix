{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (python311.withPackages(ps: with ps; [
      # General
      pip

      # Science
      matplotlib
      networkx
      numpy
      pandas
      scipy

      # Optimization
      ortools

      # Misc
      grip
    ]))
  ];
}

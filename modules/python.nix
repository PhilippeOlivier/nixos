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

      # Youtube download script
      eyeD3
      levenshtein
      lz4
      pyacoustid
      youtube-dl

      # Misc
      grip
    ]))
  ];
}

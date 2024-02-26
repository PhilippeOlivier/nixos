{ config, pkgs, ... }:

  {
  home = {
    packages = with pkgs; [
      (python311.withPackages(ps: with ps; [
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
  };
}

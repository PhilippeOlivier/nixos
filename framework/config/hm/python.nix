{
  pkgs
, ...
}:

{
  home = {
    packages = with pkgs; [
      (python311.withPackages(ps: with ps; [
        # Science
        matplotlib
        networkx
        numpy
        ortools
        pandas
        scipy

        # Misc
        grip
      ]))
    ];
  };
}

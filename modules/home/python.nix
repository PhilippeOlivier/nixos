{ config, pkgs, ... }:

{
  pkgs.python311.withPackages (p: with p; [
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
  ]);
}

#   {
#   home = {
#     packages = with pkgs; [
#       (python311.withPackages(ps: with ps; [
#         # General
#         pip

#         # Science
#         matplotlib
#         networkx
#         numpy
#         pandas
#         scipy

#         # Optimization
#         ortools

#         # Misc
#         grip
#       ]))
#     ];
#   };
# }

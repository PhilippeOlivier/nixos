{
  pkgs
, homeDirectory
, username
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

    sessionVariables.PYTHONPYCACHEPREFIX="${homeDirectory}/.pycache";  # Put all the __pycache__ directories there
    
    persistence."/nosnap/home/${username}" = {
      directories = [
        ".pycache"
      ];
    };
  };
}

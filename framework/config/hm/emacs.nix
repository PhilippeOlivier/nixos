{
  pkgs
, username
, ...
}:

{
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    startWithUserSession = "graphical";
    client = {
      enable = true;
      arguments = [
        "-c"
      ];
    };
  };

  # home = {
  #   packages = with pkgs; [
  #     source-code-pro  # Font for Emacs
  #   ];

  #   persistence."/home/${username}" = {
  #     directories = [
  #       ".emacs.d"
  #     ];
  #   };
  # };
}

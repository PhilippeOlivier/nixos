{
  programs.git = {
    enable = true;
    userName = "Philippe Olivier";
    userEmail = "philippe@pedtsr.ca";
    ignores = [
      "*~"
      ".direnv/"
      ".envrc"
      ".venv/"
      "__pycache__/"
    ];
    extraConfig.credential.helper = "cache --timeout=999999999";
  };
}

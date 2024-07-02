{
  username
, ...
}:

{
  programs.chromium = {
    enable = true;
    extensions = [
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";  # uBlock Origin
      }
    ];
  };

  home.persistence."/snap/home/${username}" = {
    directories = [
      ".cache/chromium"
      ".config/chromium"
    ];
  };
}

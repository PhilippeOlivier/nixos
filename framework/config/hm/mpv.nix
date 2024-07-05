{
  username
, ...
}

{
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      # scale = "ewa_lanczossharp";
      # cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
      hwdec = "auto";
    };
  };

  home.persistence."/nosnap/home/${username}" = {
    directories = [
      ".cache/mpv"
    ];
  };
}

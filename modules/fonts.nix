{ config, pkgs }:

{
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      hack-font
      noto-fonts
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-monochrome-emoji
    ];
  };
}

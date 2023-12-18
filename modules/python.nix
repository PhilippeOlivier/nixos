{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (python38.withPackages(ps: with ps; [ pandas requests]))
  ];
}

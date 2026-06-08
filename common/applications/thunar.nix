{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.file-roller.enable = true; # Archive backend?
  # Required to show thumbnails in thunar
  services.tumbler.enable = true;
}

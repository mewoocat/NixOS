{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Gohu" "Monofur" "ProggyClean" "RobotoMono" "SpaceMono"];})
  ];
}

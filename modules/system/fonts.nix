{
  pkgs,
  ...
}: {
  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    #(nerdfonts.override {fonts = ["Gohu" "Monofur" "ProggyClean" "RobotoMono" "SpaceMono"];})
    #(nerdfonts.override {fonts = ["SpaceMono"];})
    nerd-fonts.space-mono
  ];
}

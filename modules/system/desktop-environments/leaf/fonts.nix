{ pkgs, ... } : {

  fonts.packages = with pkgs; [
    # GUI
    rubik
    liberation_ttf
    arkpandora_ttf
    cantarell-fonts

    # Monospace
    nerd-fonts.space-mono

    # Glyphs
    material-symbols
  ];

}

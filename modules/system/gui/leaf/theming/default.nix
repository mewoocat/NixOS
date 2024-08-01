{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Theme packaging
  src = builtins.readFile ./theme.sh;
  theme = pkgs.writeShellScriptBin "theme" src;

  # Wallust packaging
  wallust = pkgs.callPackage ./wallust.nix {};
in{
  home-manager.users.${config.username} = {
    
    home.packages = with pkgs; [
      # Self packaged
      wallust
      theme

      libsForQt5.qt5ct
      qt6Packages.qt6ct
      pywal
      swww
    ];

    home.file = {

      ".config/wallust".source = ./wallust;

      # GTK 3
      ".local/share/themes/adw-gtk3".source = ./adw-gtk3;
      ".local/share/themes/adw-gtk3-dark".source = ./adw-gtk3-dark;

      # GTK 4
      ".config/gtk-4.0/gtk.css".source = ./adw-gtk3/gtk-4.0/gtk.css;

    };
  };
}

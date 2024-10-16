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
in {
  home-manager.users.${config.username} = {
    # GTK Config
    gtk = {
      enable = true;
      /*
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      */
      # whitesur-gtk-theme
      /*
      theme = {
        name = "whitesur-gtk-theme";
        package = pkgs.whitesur-gtk-theme;
      };
      */
      cursorTheme = {
        name = "capitaine-cursors";
        package = pkgs.capitaine-cursors;
        size = 24;
      };
      iconTheme = {
        name = "kora";
        package = pkgs.kora-icon-theme;
      };
    };

    # QT Config (BROKEN)
    qt = {
      enable = true;
      #style.name = "kvantum";

      platformTheme.name = "qtct";
    };

    home.packages = with pkgs; [
      # Self packaged
      wallust
      theme

      # Flake inputs
      inputs.matugen.packages.x86_64-linux.default

      # Nixpkgs
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      pywal
      swww
    ];

    home.file = {
      ".config/wallust".source = ./wallust;
      ".config/matugen".source = ./matugen;

      # GTK 3
      ".local/share/themes/adw-gtk3".source = ./adw-gtk3;
      ".local/share/themes/adw-gtk3-dark".source = ./adw-gtk3-dark;

      # GTK 4
      ".config/gtk-4.0/gtk.css".source = ./adw-gtk3/gtk-4.0/gtk.css;
    };
  };
}

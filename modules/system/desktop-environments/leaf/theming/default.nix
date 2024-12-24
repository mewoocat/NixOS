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

  environment.sessionVariables = {
    #QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  qt = {
    enable = true;

    # For gnome like style
    #platformTheme = "gnome";
    #style = "adwaita-dark";

    platformTheme = "qt5ct";

  };

  # This can be used to dynamically set gtk options
  # gsettings set org.gnome.desktop.interface icon-theme whitesur-gtk-theme
  # gsettings set org.gnome.desktop.interface cursor-theme <name>
  # gsettings set org.gnome.desktop.interface cursor-size 24

  users.users.${config.username}.packages = with pkgs; [
    # GTK
    capitaine-cursors
    (pkgs.kora-icon-theme.overrideAttrs{
      postInstall = ''
        # MODIFICATION: Overwriting with custom icons
        cp ${./../ags/ags-config/assets/bluetooth-disabled-symbolic.svg} $out/share/icons/kora/status/symbolic/bluetooth-disabled-symbolic.svg
      '';
    })
    whitesur-gtk-theme

    wallust
    theme
    inputs.matugen.packages.x86_64-linux.default
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    pywal
    swww
  ];

  homes.${config.username}.files = {
    ".config/gtk-3.0/settings.ini" = {
      clobber = true;
      text = ''
        [Settings]
        gtk-cursor-theme-name=capitaine-cursors
        gtk-cursor-theme-size=24
        gtk-icon-theme-name=whitesur-gtk-theme
      '';
    };

    ".config/wallust" = {
      clobber = true;
      source = ./wallust;
    };

    ".config/matugen" = {
      clobber = true;
      source = ./matugen;
    };

    ".local/share/themes/adw-gtk3" = {
      clobber = true;
      source = ./adw-gtk3;
    };

    ".local/share/themes/adw-gtk3-dark" = {
      clobber = true;
      source = ./adw-gtk3-dark;
    };

    ".config/gtk-4.0/gtk.css" = {
      clobber = true;
      source = ./adw-gtk3/gtk-4.0/gtk.css; 
    };

    ".config/qt5ct" = {
      clobber = true;
      source = ./qt-configs/qt5ct;
    };

    ".config/qt6ct" = {
      clobber = true;
      source = ./qt-configs/qt6ct;
    };
  };
}

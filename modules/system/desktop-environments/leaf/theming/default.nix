{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Theme manager packaging
  src = builtins.readFile ./theme.sh;
  theme = pkgs.writeShellScriptBin "theme" src;

  leaf-theme-manager = pkgs.callPackage ./LeafThemeManager {};

  # Wallust packaging
  #wallust = pkgs.callPackage ./wallust.nix {};

  # Default GTK theme
  /*
  gtk-theme = pkgs.adw-gtk3.overrideAttrs {
    postInstall = ''
      # MODIFICATION: Use color variables from leaf
      echo "@import "../../../../../.config/leaf-de/theme/gtk.css"" >> $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk.css
    '';
  };
  */
  adw-gtk3-leaf = pkgs.fetchFromGitHub {
    owner = "mewoocat";
    repo = "adw-gtk3-leaf";
    rev = "443594813831c00a7ba59f45a8442ebe9547a69d";
    sha256 = "sha256-/9TKfZiyzcaaT+jb+Tk+mrlYYUlh+kqDpPVDCQoH+R8=";
  };

in {

  environment.sessionVariables = {
    #QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  qt = {
    enable = true;

    # For gnome like style
    #platformTheme = "gnome";
    #style = "adwaita-dark";

    #platformTheme = "qt5ct";
    #platformTheme = "kde";
    #style = "kvantum";

    #platformTheme = "qtengine";
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
    #adw-gtk3 # Main GTK theme
    whitesur-gtk-theme
    orchis-theme
    shades-of-gray-theme
    nwg-look

    papirus-icon-theme
    fluent-icon-theme
    whitesur-icon-theme
    numix-icon-theme-circle
    colloid-icon-theme
    beauty-line-icon-theme
    arc-icon-theme

    #inputs.adw-gtk3-leaf.packages.${system}.default

    wallust
    theme
    inputs.matugen.packages.x86_64-linux.default
    #libsForQt5.qt5ct
    #qt6Packages.qt6ct
    pywal
    swww

    libsForQt5.qtstyleplugin-kvantum
    gruvbox-kvantum
    
    leaf-theme-manager
  ];

  hjem.users.${config.username}.files = {
    ".config/gtk-3.0/settings.ini" = {
      clobber = true;
      text = ''
        [Settings]
        gtk-cursor-theme-name=capitaine-cursors
        gtk-cursor-theme-size=24
        gtk-icon-theme-name=kora
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

    ".local/share/themes/adw-gtk3-leaf" = {
      clobber = true;
      source = "${adw-gtk3-leaf}/adw-gtk3-leaf/adw-gtk3-leaf";
    };

    ".local/share/themes/adw-gtk3-leaf-dark" = {
      clobber = true;
      source = "${adw-gtk3-leaf}/adw-gtk3-leaf/adw-gtk3-leaf-dark";
    };

    /*
    ".config/gtk-3.0/gtk.css" = {
      clobber = true;
      source = ./leaf-gtk-3.0.css; 
    };
    */

    ".config/gtk-4.0/gtk.css" = {
      clobber = true;
      source = "${adw-gtk3-leaf}/adw-gtk3-leaf/adw-gtk3-leaf-dark/gtk-4.0/gtk.css";
    };

    /*
    ".config/qt5ct" = {
      clobber = true;
      source = ./qt-configs/qt5ct;
    };

    ".config/qt6ct" = {
      clobber = true;
      source = ./qt-configs/qt6ct;
    };
    */
  };
}

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
        package = pkgs.kora-icon-theme.overrideAttrs (finalAttrs: previousAttrs: {
          # Based off of https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/icons/kora-icon-theme/default.nix#L53
          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/icons
            cp -a kora* $out/share/icons/

            # MODIFICATION: Overwriting with custom icons
            cp ${./../ags/ags-config/assets/bluetooth-disabled-symbolic.svg} $out/share/icons/kora/status/symbolic/bluetooth-disabled-symbolic.svg

            rm $out/share/icons/kora*/create-new-icon-theme.cache.sh

            for theme in $out/share/icons/*; do
              gtk-update-icon-cache -f $theme
            done

            runHook postInstall
          '';
        });
      };
    };

    # QT Config (BROKEN)
    /*
    qt = {
      enable = true;
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
      platformTheme = {
        name = "qt5ct";
      };
    };
    */

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

    systemd.user.tmpfiles.rules = [
      # QT configs
      "L+ /home/${config.username}/.config/qt5ct - - - - /home/${config.username}/NixOS/modules/system/desktop-environments/leaf/theming/qt-configs/qt5ct"
      "L+ /home/${config.username}/.config/qt6ct - - - - /home/${config.username}/NixOS/modules/system/desktop-environments/leaf/theming/qt-configs/qt6ct"
    ];
  };
}

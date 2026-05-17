{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let

  leaf-theme-manager = pkgs.callPackage ./LeafThemeManager {};

in {

  imports = [
    ./qt.nix
    ./gtk.nix
    ./matugen
  ];

  users.users.${config.username}.packages = with pkgs; [

    # Icon themes
    (pkgs.kora-icon-theme.overrideAttrs{
      /*
      postInstall = ''
        # MODIFICATION: Overwriting with custom icons
        cp ${./../ags/ags-config/assets/bluetooth-disabled-symbolic.svg} $out/share/icons/kora/status/symbolic/bluetooth-disabled-symbolic.svg
      '';
      */
    })
    papirus-icon-theme
    fluent-icon-theme
    whitesur-icon-theme
    colloid-icon-theme
    arc-icon-theme
    reversal-icon-theme
    kdePackages.breeze-icons
    kora-icon-theme

    # Cursors
    capitaine-cursors

    wallust
    #libsForQt5.qt5ct
    #qt6Packages.qt6ct
    leaf-theme-manager
    swww # Wallpaper manager
    inputs.matugen.packages.x86_64-linux.default

  ];

  hjem.users.${config.username} = {
    clobberFiles = true;
    files = {

      ".config/wallust" = {
        source = ./wallust;
      };

    };
  };
}

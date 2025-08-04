{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [

    # Installing globally to appease qmlls
    # https://quickshell.outfoxxed.me/docs/configuration/getting-started/
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell package
    kdePackages.qtdeclarative # Add qml types in path for qmlls
    kdePackages.qt5compat # For Qt5Compat.GraphicalEffects

    # For styling QtQuick controls within Quickshell
    kdePackages.qqc2-desktop-style # Kde's QtQuick controls which uses the applcations QStyle theme
    kdePackages.sonnet # Not sure if this is needed
    pkgs.kdePackages.kirigami.passthru.unwrapped # Need the unwrapped version for kde's qqc2 style (i think)

    # Icon theme
    kdePackages.breeze
    
    # Qt styles
    darkly
    adwaita-qt6
    kdePackages.oxygen
    libsForQt5.qtstyleplugins
  ];

  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/quickshell" = {
        #source = ./config;
        source = "/home/eXia/NixOS/modules/system/desktop-environments/leaf/quickshell/config/"; # For development
        clobber = true;
      };
    };
  };

}

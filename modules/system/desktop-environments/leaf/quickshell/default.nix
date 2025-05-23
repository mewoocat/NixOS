{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let

in {
  users.users.${config.username}.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell package
  ];  

  /*
  environment.pathsToLink = [
    "${pkgs.kdePackages.kirigami}/lib/qt-6/qml/org/kde/kirigami"
    #"/lib/qt-6/"
    #"/lib/qt-6/qml/org/kde/kirigami"
  ];
  */

  /*
  environment.variables = {
    QML2_IMPORT_PATH = "${pkgs.kdePackages.kirigami}/lib/qt-6/qml";
  };
  */

  environment.systemPackages = with pkgs; [
    # For styling QtQuick controls
    kdePackages.qqc2-desktop-style
    kdePackages.sonnet

    kdePackages.breeze

    kdePackages.kirigami
    kdePackages.kirigami-addons
  ];

  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/quickshell" = {
        source = ./config;
        clobber = true;
      };
    };
  };

}

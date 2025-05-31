{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let

in {

  users.users.${config.username}.packages = with pkgs; [
    #inputs.quickshell.packages.${pkgs.system}.default # Quickshell package
  ];  

  /*
  environment.pathsToLink = [
    "${pkgs.kdePackages.kirigami}/lib/qt-6/qml/org/kde/kirigami"
    #"/lib/qt-6/"
    #"/lib/qt-6/qml/org/kde/kirigami"
  ];
  */

  # Need to manually add these paths to allow for qmlls to recognize the qtquick imports
  environment.variables = let 
    extraQmlPaths = [
      # kirigami is wrapped, access the unwrapped version to retrieve binaries/source files
      "${pkgs.kdePackages.kirigami.passthru.unwrapped}/lib/qt-6/qml"

      "${pkgs.kdePackages.kirigami}/lib/qt-6/qml"
      "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml/"
      "${pkgs.kdePackages.qtbase}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    ];
  in {
    QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${lib.strings.concatStringsSep ":" extraQmlPaths}";
  };

  environment.systemPackages = with pkgs; [

    # Installing globally to appease qmlls
    # https://quickshell.outfoxxed.me/docs/configuration/getting-started/
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell package

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

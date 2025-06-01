{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let

in {

  # Some addition qml module paths needed for qmlls and quickshell
  environment.variables = let 
    extraQmlPaths = [
      # kirigami is wrapped, access the unwrapped version to retrieve binaries/source files
      "${pkgs.kdePackages.kirigami.passthru.unwrapped}/lib/qt-6/qml"
      "${inputs.quickshell.packages.${pkgs.system}.default}/lib/qt-6/qml/"
      "${pkgs.kdePackages.qtbase}/lib/qt-6/qml"
      "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
    ];
  in {
    # May not need to append here since pretty much everything we need is included
    QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${lib.strings.concatStringsSep ":" extraQmlPaths}";
  };

  environment.systemPackages = with pkgs; [

    # Installing globally to appease qmlls
    # https://quickshell.outfoxxed.me/docs/configuration/getting-started/
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell package

    # For styling QtQuick controls within Quickshell
    kdePackages.qqc2-desktop-style
    kdePackages.sonnet
    kdePackages.kirigami
    kdePackages.kirigami-addons # Not sure if this is needed

    # Icon theme
    kdePackages.breeze

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

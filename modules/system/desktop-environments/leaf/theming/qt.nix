{config, pkgs, inputs, ...} : {

  imports = [
    inputs.qtengine.nixosModules.default
  ];

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

  environment.systemPackages = with pkgs; [
    # QT Styles
    kdePackages.breeze
    kdePackages.breeze.qt5 # For Qt5 support
    darkly
    darkly-qt5 # For Qt5 support
    adwaita-qt
    qlementine

    inputs.qtengine.packages.${stdenv.hostPlatform.system}.default # For imperative qtengine config management
  ];

  programs.qtengine = {
    enable = false;
    config = {
      theme = {
        # Note that this file apparently affect the colors of icons
        colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        #colorScheme = "${leaf-dir}/qtengine.colors";
        iconTheme = "kora";
        style = "darkly";
        font = {
          family = "Rubik";
          size = 11;
          weight = -1;
        };
        fontFixed = {
          family = "SpaceMono Nerd Font";
          size = 11;
          weight = -1;
        };
      };
      misc = {
        menusHaveIcons = true;
      };
    };
  };

  hjem.users.${config.username} = {
    clobberFiles = true;
    files = {

      ".config/qtengine/config.json" = {
        #source = ./qtengine.json;
        source = "/home/eXia/NixOS/modules/system/desktop-environments/leaf/theming/qtengine.json"; # For development
      };

    };
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  types-path = "/share/com.github.Aylur.ags/types";
  ags-package = inputs.ags.packages.${pkgs.system}.default.override {
    extraPackages = with pkgs;[
      #libdbusmenu-gtk3
      gtk-session-lock
    ];
    #buildTypes = true;
  };
in {
  # For AGS Screenlock
  security.pam.services.ags = {};
  home-manager.users.${config.username} = {
    imports = [
      inputs.ags.homeManagerModules.default # Import ags hm module
    ];

    programs.ags = {
      enable = true;
    };
  };

  # This breaks the boot process
  /*
  services.greetd = {
    enable = true;
  };
  */

  #home-manager.users.${config.username}.home.packages = [ags-package];


  users.users.${config.username}.packages = with pkgs; [
    #ags-package

    # Dependencies
    sassc
    wf-recorder
    slurp # Used to select screen in wf-recorder
    python312Packages.gpustat
  ];  

  homes.eXia = {
    enable = true;
    files = {
      ".config/ags" = {
        source = "/home/${config.username}/NixOS/modules/system/desktop-environments/leaf/ags/ags-config";
        clobber = true;
      };
      ".local/share/fonts/icon_font.ttf" = {
        source = ./ags-config/assets/icon_font.ttf;
        clobber = true;
      };
      /*
      ".local/${types-path}" = {
        source = "${ags-package}/${types-path}";
        clobber = true;
      };
      */
    };
  };

}

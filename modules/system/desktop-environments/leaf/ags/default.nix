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

  # This breaks the boot process
  /*
  services.greetd = {
    enable = true;
  };
  */

  users.users.${config.username}.packages = with pkgs; [
    ags-package

    # Dependencies
    bun # For transpiling typescript
    sassc # scss transpiler
    wf-recorder # Screen recording
    slurp # Used to select screen in wf-recorder
    python312Packages.gpustat
  ];  

  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/ags" = {
        source = ./ags-config;
        clobber = true;
      };
      ".local/share/fonts/icon_font.ttf" = {
        source = ./ags-config/assets/icon_font.ttf;
        clobber = true;
      };
      # Doesn't seem like this is needed
      /*
      ".local/${types-path}" = {
        source = "${ags-package}/${types-path}";
        clobber = true;
      };
      */
    };
  };

}

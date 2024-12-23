{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # For AGS Screenlock
  security.pam.services.ags = {};

  # This breaks the boot process
  /*
  services.greetd = {
    enable = true;
  };
  */

  users.users.${config.username}.packages = with pkgs; [
    inputs.ags.packages.${pkgs.system}.default
    libdbusmenu-gtk3

    # Dependencies
    gtk-session-lock
    sassc
    wf-recorder
    slurp # Used to select screen in wf-recorder
    python312Packages.gpustat
    gtk-session-lock
  ];  

  homes.eXia = {
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
    };
  };

}

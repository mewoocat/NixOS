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

  # Home manager config
  home-manager.users.${config.username} = {
    imports = [
      inputs.ags.homeManagerModules.default # Import ags hm module
    ];

    programs.ags = {
      enable = true;

      # additional packages to add to gjs's runtime
      extraPackages = with pkgs; [
        gtk-session-lock
        #coreutils # For date
      ];
    };

    home.packages = with pkgs; [
      sassc
      wf-recorder
      slurp # Used to select screen in wf-recorder
      python312Packages.gpustat
      gtk-session-lock
    ];

    systemd.user.tmpfiles.rules = [
      # There's probably a better way to do this
      "L+ /home/${config.username}/.config/ags - - - - /home/${config.username}/NixOS/modules/system/desktop-environments/leaf/ags/ags-config" # Symlink ags config to .config
      "L+ /home/${config.username}/.local/share/fonts/icon_font.ttf - - - - ${./ags-config/assets/icon_font.ttf}" # Symlink icon font
    ];
  };
}

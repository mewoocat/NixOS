
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 

{
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
    home.file = {
      # this no work
      #".config/ags".source = config.home-manager.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/users/eXia/ags";        
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
      "L+ /home/${config.username}/.config/ags - - - - /home/${config.username}/NixOS/modules/system/gui/leaf/ags/ags-config"
    ];
  };
}

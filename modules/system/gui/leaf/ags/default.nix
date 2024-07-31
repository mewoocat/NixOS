
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
    systemd.user.tmpfiles.rules = [
      "L+ /home/${config.username}/.config/ags - - - - /home/${config.username}/NixOS/users/eXia/ags"
    ];
  };
}

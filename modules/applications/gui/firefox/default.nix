{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: 
{
  /*
  home-manager.users.${config.username} = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
        };
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
  */

  programs.firefox.enable = true;
}

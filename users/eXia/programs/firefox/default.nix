{ config, pkgs, lib, inputs, ... }: 
{
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
}

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "eXia";
in {
  #home-manager.users.${username}.programs.firefox = {
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

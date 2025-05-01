{
  config,
  pkgs,
  inputs,
  ...
}: let

in {
  users.users.${config.username}.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.system}.default # Quickshell package

  ];  

  hjem.users.eXia = {
    enable = true;
    files = {
      ".config/quickshell" = {
        source = ./config;
        clobber = true;
      };
    };
  };

}

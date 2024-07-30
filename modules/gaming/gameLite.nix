{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let 
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: true;

  home-manager.users.${config.username}.home.packages = with pkgs; [
    # Games
    mgba
  ];
}

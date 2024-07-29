
{ config, pkgs, lib, inputs, ... }: 
let
  username = "eXia";
in
{
  imports = [

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home-manager.users.${username}.home.packages = with pkgs; [
    # Games
    mgba
  ];

}


{ config, pkgs, lib, inputs, ... }: 

{
  imports = [

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home.packages = with pkgs; [
    # Games
    mgba
  ];

}

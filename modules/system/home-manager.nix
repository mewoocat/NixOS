# Imports the home-manager nixos module from the flake inputs so that
# home-manager options can be used like any other nixos option
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
    }
  ];
}

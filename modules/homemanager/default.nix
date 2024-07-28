
{ pkgs, config, lib, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];
}


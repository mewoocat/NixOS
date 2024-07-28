# Host: scythe
# Razer blade stealth late 2016

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  # NixOS modules
  modules = [ 

    /*
    # Add home-manager options
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
    */
    ../../modules/homemanager

    ./hardware-configuration.nix
    ../../nixos/configuration.nix 
    ../../nixos/hardware/razer.nix
    ../../users/eXia
  ];
}

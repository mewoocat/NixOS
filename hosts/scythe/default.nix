# Host: scythe
# Razer blade stealth late 2016

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ 
    ./hardware-configuration.nix
    ../../nixos/configuration.nix 
    ../../nixos/hardware/razer.nix
    #./nixos/gnome.nix
    ../../modules/homemanager

    /*
    # TODO: Move to seperate file?
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.eXia = {
        imports = [
          ../../users/eXia/home.nix
          #./home-manager/gnome.nix
          ../../users/eXia/programs/game/gameLite.nix
        ];
      };
    }
    */
  ];
}

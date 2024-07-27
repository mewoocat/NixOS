# Host: obsidian
# Ryzen 5 + GTX 1080 / RX 470 Desktop

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ 
    ./hardware-configuration.nix
    ../../nixos/hardware/razer.nix
    ../../nixos/configuration.nix

    # Home Manager
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.eXia = {
        imports = [
          ../../users/eXia/home.nix
          ../../users/eXia/programs/game/game.nix
        ];
      };
    }

  ];
}

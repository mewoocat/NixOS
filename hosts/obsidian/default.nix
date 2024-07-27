# Host: obsidian
# Ryzen 5 + GTX 1080 / RX 470 Desktop

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ 
    ./hardware-configuration.nix
    ../../nixos/hardware/razer.nix
    ../../nixos/configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.eXia = {
        imports = [
          ../../home-manager/home.nix
          ../../home-manager/programs/game/game.nix
        ];
      };
    }
  ];
}

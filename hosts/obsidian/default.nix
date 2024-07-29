# Host: obsidian
# Ryzen 5 + GTX 1080 / RX 470 Desktop

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ 
    ../../modules/system                    # Core system components
    ../../modules/homemanager               # Installs home-manager 

    # Hardware
    ./hardware-configuration.nix
    ../../modules/hardware/razer.nix

    ../../users/eXia
    ../../modules/gaming/game.nix

  ];
}

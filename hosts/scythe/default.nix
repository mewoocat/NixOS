# Host: scythe
# Razer blade stealth late 2016

{ inputs }:

inputs.nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  # NixOS modules
  modules = [ 
    ../../modules/system                    # Core system components
    ../../modules/homemanager               # Installs home-manager 

    # Hardware
    ./hardware-configuration.nix
    ../../modules/hardware/razer.nix

    ../../modules/gaming/gameLite.nix
    ../../users/eXia
  ];
}

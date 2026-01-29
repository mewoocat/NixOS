{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs;};
  # NixOS modules
  modules = [

    inputs.Jovian-NixOS.nixosModules.default

    # Core system config
    ./core.nix

    # Hardware
    ./hardware-configuration.nix


    # Desktop environment
    ../../modules/system/desktop-environments/kde

    #../../modules/gaming/gameLite.nix

    # Utilities
    #../../modules/utilities

  ];
}

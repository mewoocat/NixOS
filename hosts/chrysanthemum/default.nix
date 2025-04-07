{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  # NixOS modules
  modules = [
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

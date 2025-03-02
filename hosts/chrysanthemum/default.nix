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

    # Core system components
    ../../modules/system

    # Desktop environment
    ../../modules/system/desktop-environments/kde

    # Users
    ../../users/eXia
    ../../modules/gaming/gameLite.nix

    # Utilities
    ../../modules/utilities

  ];
}

# Host: maple
# Nextcloud home server
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  modules = [
    # Hardware
    ./hardware-configuration.nix

    # Core system components
    ../../modules/system

    # User
    ../../users/eXia

    # Utilities
    ../../modules/utilities
  ];
}

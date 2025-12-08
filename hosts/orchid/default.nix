# Host: orchid
# Ryzen 5 1600 + GTX 1060 Desktop
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  modules = [
    # Core host related configuration
    ./core.nix

    # Hardware
    ./hardware-configuration.nix
    ../../modules/hardware/bluetooth.nix
    #../../modules/hardware/drawing-tablet.nix
    ../../modules/hardware/ios.nix
    ../../modules/hardware/razer.nix
    ../../modules/hardware/rgb.nix
    ../../modules/hardware/vial-keyboards.nix
    ../../modules/hardware/nvidia.nix

    # Core system components
    ../../modules/system

    # Desktop environment
    #../../modules/system/desktop-environments/leaf
    ../../modules/system/desktop-environments/kde

    # User
    ../../users/iris
    ../../users/eXia

    # Other
    ../../modules/utilities
    ../../modules/gaming/game.nix
  ];
}

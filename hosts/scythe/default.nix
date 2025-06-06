# Host: scythe
# Razer blade stealth late 2016
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
    ../../modules/hardware/bluetooth.nix
    #../../modules/hardware/drawing-tablet.nix
    #../../modules/hardware/ios.nix
    ../../modules/hardware/razer.nix
    ../../modules/hardware/rgb.nix
    ../../modules/hardware/vial-keyboards.nix

    # Core system components
    ../../modules/system

    # Desktop environment
    ../../modules/system/desktop-environments/leaf
    #../../modules/system/desktop-environments/kde

    # Users
    ../../users/eXia
    ../../modules/gaming/gameLite.nix

    # Utilities
    ../../modules/utilities

    ./patches.nix
  ];
}


# Host: toshiba
# Early 2010s Toshiba laptop
# 
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  # NixOS modules
  modules = [

    ./configuration.nix

    # Hardware
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/drawing-tablet.nix
    ../../modules/hardware/ios.nix
    ../../modules/hardware/vial-keyboards.nix

    # Core system components
    ../../modules/system

    # Desktop environment
    ../../modules/system/desktop-environments/leaf

    # Users
    ../../users/eXia
    ../../modules/gaming/gameLite.nix

    # Utilities
    ../../modules/utilities

    ./custom-inputs.nix

  ];
}

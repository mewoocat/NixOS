# Host: scythe
# Razer blade stealth late 2016
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  # NixOS modules
  modules = [
    # Users
    ../../users/eXia

    ../../modules/system # Core system components
    ../../modules/homemanager # Installs home-manager

    # Hardware
    ./hardware-configuration.nix
    ../../modules/hardware/razer.nix

    ../../modules/gaming/gameLite.nix
  ];
}

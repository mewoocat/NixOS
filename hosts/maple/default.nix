# Host: maple
# Nextcloud home server
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  modules = [
    ./core.nix
    #./hardware-configuration.nix
    ../../modules/servers/nextcloud

    ./disk-config.nix # Disk setup for nixos-anywhere

    # User
    #../../users/eXia # need to add user without all the other junk

  ];
}

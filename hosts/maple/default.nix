# Host: maple
# Nextcloud home server
{inputs}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {inherit inputs;};
  modules = [
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default

    ./core.nix
    ./hardware-configuration.nix

    ./disk-config.nix # Disk setup for nixos-anywhere

    # User
    #../../users/eXia # need to add user without all the other junk

    # Services
    ../../modules/servers/nextcloud
    ../../modules/servers/ad-guard-home
    ../../modules/servers/owntracks
    ../../modules/servers/fail2ban
    #../../modules/servers/traccar

    # Desktop environment
    #../../modules/system/desktop-environments/kde

  ];
}

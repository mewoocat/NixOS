{ inputs, ... }:
# NixOS system configs
{
  # Razer blade stealth late 2016
  scythe = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ 
      ./scythe 
      ../nixos/configuration.nix 
      #./nixos/gnome.nix

      # TODO: Move to seperate file?
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.eXia = {
          imports = [
            ../home-manager/home.nix
            #./home-manager/gnome.nix
            ../home-manager/programs/game/gameLite.nix
          ];
        };
      }
    ];
  };

  # Ryzen 5 + GTX 1080 / RX 470 Desktop
  obsidian = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ 
      ./obsidian
      ../nixos/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.eXia = {
          imports = [
            ../home-manager/home.nix
            ../home-manager/programs/game/game.nix
          ];
        };
      }
    ];
  };
}

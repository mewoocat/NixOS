
{ inputs }:

inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.eXia = {
        imports = [
          ../../users/eXia/home.nix
          #./home-manager/gnome.nix
          ../../users/eXia/programs/game/gameLite.nix
        ];
      };
}


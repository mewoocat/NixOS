{config, pkgs, inputs, ...}:
{
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
}

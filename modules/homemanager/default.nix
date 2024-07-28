
{config, pkgs, inputs, ...}:

{

  inputs.home-manager.nixosModules.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.eXia = {
      imports = [
        ../../users/eXia/home.nix
        #./home-manager/gnome.nix
        ../../users/eXia/programs/game/gameLite.nix
      ];
    };
  };

}


{config, pkgs, inputs, ...}:
{
    home-manager.users.eXia = {
      imports = [
        ./home.nix
      ];
    };
}

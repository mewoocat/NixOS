{
  description = "NixOS and Homemanager flake";
  
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    #home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # AGS
    ags.url = "github:Aylur/ags";

    # Matugen
    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";

    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    #hyprland.url = "github:hyprwm/Hyprland";
    # Temp fix
    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland = {
        url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.40.0&submodules=1";
        inputs.nixpkgs.follows = "nixpkgs"; # Fix for amd card ?
    };
    hyprspace = {
        url = github:KZDKM/Hyprspace;
        inputs.hyprland.follows = "hyprland";
    };
   
    # My nvim config
    myNvim.url = "github:mewoocat/nvim-nix";


  };

  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function. 
  outputs = inputs@{ self, nixpkgs, home-manager, anyrun, ... }:
  let
 	pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {

    # NixOS system configs
    nixosConfigurations = {

      # Razer blade stealth late 2016
      scythe = nixpkgs.lib.nixosSystem {
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/scythe 
          ./nixos/configuration.nix 

          # TODO: Move to seperate file?
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.eXia = {
              imports = [
                anyrun.homeManagerModules.default
                ./home-manager/home.nix
                ./home-manager/programs/game/gameLite.nix
              ];
            };
            #home-manger.home.packages = [ self.packages.x86_64-linux.nvim ];
          }
        ];
      };

      # Ryzen 5 + GTX 1080 / RX 470 Desktop
      obsidian = nixpkgs.lib.nixosSystem {
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ 
          ./hosts/obsidian
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.eXia = {
              imports = [
                anyrun.homeManagerModules.default
                ./home-manager/home.nix
                ./home-manager/programs/game/game.nix
              ];
            };
          }
        ];
      };
    };

  };
}

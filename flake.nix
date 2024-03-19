{
  description = "NixOS and Homemanager flake";
  
  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # AGS
    ags.url = "github:Aylur/ags";

    # Matugen
    matugen = {
      url = "github:/InioX/Matugen";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    

  };

  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function. 
  outputs = inputs@{ self, nixpkgs, home-manager, anyrun, nixvim, ... }:
  let
    nvimConfig = import ./home-manager/nixvim.nix;
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
                ./home-manager/gameLite.nix
              ];
            };
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
                ./home-manager/game.nix
              ];
            };
          }
        ];
      };
    };

    # Homemanager standalone (Depreciated)
    homeConfigurations = {

      "eXia@scythe" = home-manager.lib.homeManagerConfiguration {
 	      pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          anyrun.homeManagerModules.default
          ./home-manager/home.nix 
          ./home-manager/gameLite.nix
        ];
      };

      "eXia@obsidian" = home-manager.lib.homeManagerConfiguration {
 	      pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          anyrun.homeManagerModules.default
          ./home-manager/home.nix 
          ./home-manager/game.nix
        ];
      };

    };

    # Outputted packages
    packages.x86_64-linux = {
      # Output nixvim + config as package
      # Imports the nixvim set
      nvim = nixvim.legacyPackages.x86_64-linux.makeNixvim (import ./home-manager/nixvim.nix);
    };
  };
}

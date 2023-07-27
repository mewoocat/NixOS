{
  description = "My NixOS and Homemanager config";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }: {

    # System config
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration.nix ];
      };
    };

    # Homemanager
    homeConfigurations = {
      "exia@nixos" = home-manager.lib.homeManagerConfiguration {
 	pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
          ./home-manager/home.nix 
        ];

      };
    };

  };
}

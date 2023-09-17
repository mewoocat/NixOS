{
  description = "NixOS and Homemanager flake";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    #home-manager.url = "github:nix-community/home-manager/release-23.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, anyrun, ... }: {

    # NixOS system config
    nixosConfigurations = {

      # Razer blade stealth late 2016
      "scythe" = nixpkgs.lib.nixosSystem {
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration.nix ];
      };

    };

    # Homemanager
    homeConfigurations = {

      "exia@scythe" = home-manager.lib.homeManagerConfiguration {
 	      pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          hyprland.homeManagerModules.default
          anyrun.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
          ./home-manager/home.nix 
        ];
      };

    };

  };
}

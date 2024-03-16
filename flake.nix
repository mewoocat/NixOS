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
    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland-plugins = {
    #  url = "github:hyprwm/hyprland-plugins";
    #  inputs.hyprland.follows = "hyprland";
    #};

    # Anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # AGS
    ags.url = "github:Aylur/ags";

    # Matugen
    matugen = {
      url = "github:/InioX/Matugen";
      # If you need a specific version:
      #ref = "refs/tags/matugen-v0.10.0"
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function. 
  outputs = inputs@{ self, nixpkgs, home-manager, anyrun, nixvim, flake-parts, ... }:
  {

    # NixOS system config
    nixosConfigurations = {

      # Razer blade stealth late 2016
      scythe = nixpkgs.lib.nixosSystem {
        # if nixpkgs.hostPlatform is set, which is probably is if you have a hardware-configuration.nix file, you do not need to use it
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/scythe ./nixos/configuration.nix ];
      };

      # Ryzen 5 + GTX 1080 / RX 470 Desktop
      obsidian = nixpkgs.lib.nixosSystem {
        #system = "x86_64-Linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/obsidian ./nixos/configuration.nix ];
      };

    };

    # Homemanager
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

    packages.x86_64-linux = {
      # Output nixvim + config as package
      nvim = nixvim.legacyPackages."".makeNixvim {
        colorschemes.gruvbox.enable = true;
      };
      default = nvim;
    };
  };
}

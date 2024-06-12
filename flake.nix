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
    #ags.url = "github:mewoocat/ags-testing";

    # Matugen
    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland = {
        #url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.40.0&submodules=1";
        #0.39.0 0.38.1
        #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.38.0&submodules=1"; # Doesn't work
        #url = "git+https://github.com/hyprwm/Hyprland?ref=master&rev=108163f1e5e0e1423a170e78688a826963ec7a81&submodules=1"; # Doesn't work

        # https://github.com/hyprwm/Hyprland/commit/ca17a89d86b73f37019c4cc0c7087303adbcc1f9
        #url = "git+https://github.com/hyprwm/Hyprland?ref=master&rev=ca17a89d86b73f37019c4cc0c7087303adbcc1f9&submodules=1"; # This one breaks it

        #url = "git+https://github.com/hyprwm/Hyprland?ref=master&rev=356414639fc06ace7045236ec41d673342981057&submodules=1"; # Works
        #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.37.1&submodules=1"; # Popup blur works
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

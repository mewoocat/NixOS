{
  description = "NixOS and Homemanager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/0d40d3a1ff082aa0ea314d8170f46d66f0b82c8b"; # Unstable pinned
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    #home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ags.url = "github:Aylur/ags";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    nix-gaming.url = "github:fufexan/nix-gaming";
    myNvim.url = "github:mewoocat/nvim-nix";
    microfetch.url = "github:NotAShelf/microfetch";

    hyprland = {
      #url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?rev=a71207434c0bc2c8e05e94b1619e68059a002879&submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.39.1&submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.41.1&submodules=1"; # The only good version
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.42.0&submodules=1";
    };

    hyprland-wlr = {
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.41.1&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
    };
    /*
    hyprspace = {
      url = github:KZDKM/Hyprspace;
      inputs.hyprland.follows = "hyprland";
    };
    */

    # My nvim config

    # Nix formatter
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    
    # 3DS dev
    /*
    devkitnix = {
      url = "github:knarkzel/devkitnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */

  };

  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = {self, ...} @ inputs: let
    # Call the function in ./hosts/default.nix with inputs as the argument
    hosts = import ./hosts {inputs = inputs;};
  in {
    formatter."x86_64-linux" = inputs.alejandra.defaultPackage."x86_64-linux";
    nixosConfigurations = hosts;
  };
}

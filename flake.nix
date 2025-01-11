{
  description = "NixOS and Homemanager flake";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    #nixpkgs.url = "github:NixOS/nixpkgs/0d40d3a1ff082aa0ea314d8170f46d66f0b82c8b"; # Unstable pinned
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    #ags.url = "github:Aylur/ags";
    #ags.url = "git+https://github.com/Aylur/ags?ref=refs/tags/v1.8.2";
    ags.url = "git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d";
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    nix-gaming.url = "github:fufexan/nix-gaming";
    myNvim.url = "github:mewoocat/nvim-nix";
    myNvimNvf.url = "github:mewoocat/nvim-nvf";
    microfetch.url = "github:NotAShelf/microfetch";
    adw-gtk3-leaf.url = "github:mewoocat/adw-gtk3-leaf";
    ghostty.url = "github:ghostty-org/ghostty";
    agenix.url = "github:ryantm/agenix"; # For secret management

    hyprland = {
      #url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?rev=a71207434c0bc2c8e05e94b1619e68059a002879&submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.39.1&submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.41.1&submodules=1"; # The only good version
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.42.0&submodules=1";
      #url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.45.2&submodules=1"; 
    };

    hyprland-wlr = {
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.41.1&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-laptop = {
      #url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.44.1&submodules=1";
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.45.2&submodules=1";
      #inputs.nixpkgs.follows = "nixpkgs-stable";
      #inputs.nixpkgs.follows = "nixpkgs";
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
    
    zen-browser.url = "github:MarceColl/zen-browser-flake";

    hjem.url = "github:feel-co/hjem";

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

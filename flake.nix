{
  description = "NixOS and Homemanager flake";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-server.url = "github:NixOS/nixpkgs/nixos-25.05";
    #ags.url = "git+https://github.com/Aylur/ags?ref=refs/tags/v1.8.2";
    ags.url = "git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d"; # ags v1
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    nix-gaming.url = "github:fufexan/nix-gaming";
    myNvim.url = "github:mewoocat/nvim-nix";
    myNvimNvf.url = "github:mewoocat/nvim-nvf";
    microfetch.url = "github:NotAShelf/microfetch";
    #adw-gtk3-leaf.url = "github:mewoocat/adw-gtk3-leaf";
    agenix.url = "github:ryantm/agenix"; # For secret management
    disko.url = "github:nix-community/disko";
    hjem.url = "github:feel-co/hjem"; 
    secrets = {
      url = "git+ssh://git@github.com/mewoocat/secrets?ref=main";
      flake = false;
    };

    hyprland = {
      #url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?rev=a71207434c0bc2c8e05e94b1619e68059a002879&submodules=1";
      #url = "git+https://github.com/hyprwm/Hyprland?ref=refs/tags/v0.41.1&submodules=1"; # The only good version
      #url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.42.0&submodules=1"; # TF2 works on this one
      #url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.47.0&submodules=1"; # No gpu found error
      #url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.49.0&submodules=1"; # Hypr bars fails
      url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.51.0&submodules=1";
      #url = "github:hyprwm/Hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
    };

    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins?ref=refs/tags/v0.51.0";
      inputs.hyprland.follows = "hyprland";
    };

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
    
    quickshell = {
      #url = "git+https://git.outfoxxed.me/quickshell/quickshell?ref=refs/tags/v0.2.0";
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = {self, ...} @ inputs: let
    # Call the function in ./hosts/default.nix with inputs as the argument
    hosts = import ./hosts {inputs = inputs;};
  in {
    formatter."x86_64-linux" = inputs.alejandra.defaultPackage."x86_64-linux";

    # My machines :)
    nixosConfigurations = hosts;
  };
}

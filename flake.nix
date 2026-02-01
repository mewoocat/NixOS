{
  description = "NixOS and Homemanager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-server.url = "github:NixOS/nixpkgs/nixos-25.11";
    ags.url = "git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d"; # ags v1
    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    nix-gaming.url = "github:fufexan/nix-gaming";
    myNvimNvf.url = "github:mewoocat/nvim-nvf";
    microfetch.url = "github:NotAShelf/microfetch";
    agenix.url = "github:ryantm/agenix"; # For secret management
    disko.url = "github:nix-community/disko";
    hjem.url = "github:feel-co/hjem";
    hyprland.url = "git+https://github.com/hyprwm/hyprland?ref=refs/tags/v0.53.0&submodules=1";
    hypridle.url = "github:hyprwm/hypridle";
    hyprland-plugins = {
      url = "git+https://github.com/hyprwm/hyprland-plugins?ref=refs/tags/v0.53.0";
      inputs.hyprland.follows = "hyprland";
    };
    secrets = {
      url = "git+ssh://git@github.com/mewoocat/secrets?ref=main";
      flake = false;
    };
    # Nix formatter
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    quickshell = {
      #url = "git+https://git.outfoxxed.me/quickshell/quickshell?ref=refs/tags/v0.2.0";
      #url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    Jovian-NixOS = {
      #url = "github:Jovian-Experiments/Jovian-NixOS";
      url = "git+https://github.com/Jovian-Experiments/Jovian-NixOS?rev=68a1bcc019378272e601558719f82005a80ddab0";
    };
    qtengine = {
      url = "github:kossLAN/qtengine";
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

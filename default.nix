# TODO
# - look into tack

let
  sources = import ./npins;

  # Flake compatibility
  #getFlakeOutputs = npinsSource: (import sources.flake-compat { src = npinsSource; }).outputs;
  getFlakeOutputs = {npinsSource, followsNixpkgs ? false}: ((import sources.flake-inputs).import-flake {
    src = npinsSource;
    overrides = if followsNixpkgs then { nixpkgs = sources.nixpkgs.outPath; } else {};
  });
  inputs = {
    hjem = getFlakeOutputs { npinsSource = sources.hjem; };
    matugen = getFlakeOutputs { npinsSource = sources.matugen; };
    #quickshell = getFlakeOutputs sources.quickshell; # borked
    #niri = getFlakeOutputs sources.niri;
    #qtengine = getFlakeOutputs sources.qtengine;

    # This uses flake-inputs instead of flake-compat, in order to override the nixpkgs dependency.  qtengine requires this or else issues can occur due to mismatches
    #qtengine =  (import sources.flake-inputs).import-flake { src = sources.qtengine; overrides = { nixpkgs = sources.nixpkgs.outPath; }; };
    qtengine = getFlakeOutputs { npinsSource = sources.qtengine; followsNixpkgs = true; };
    nix-gaming = getFlakeOutputs { npinsSource = sources.nix-gaming; };
    nvim-nvf = getFlakeOutputs { npinsSource = sources.nvim-nvf; };
  };

  # System builder
  nixpkgs = sources.nixpkgs;
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix"; # Same thing as flake nixpkgs.lib.nixosSystem, apparently what nixos-rebuild also uses 
  makeNixosSystem = configPath: nixosSystem {
    modules = [ configPath ];
    specialArgs = {
      inherit inputs; # Flake inputs attrbute sets
      inherit sources; # Source input paths
    };
  };

in {
  inherit inputs;
  inherit sources;
  scythe = makeNixosSystem ./hosts/scythe/configuration.nix;
  obsidian = makeNixosSystem ./hosts/obsidian/configuration.nix;
  maple = makeNixosSystem ./hosts/maple/configuration.nix;
  chrysanthemum = makeNixosSystem ./hosts/chrysanthemum/configuration.nix;
  orchid = makeNixosSystem ./host/orchid/configuration.nix;
}

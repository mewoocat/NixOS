let
  sources = import ./npins;
  nixpkgs = sources.nixpkgs;
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix"; # Same thing as flake nixpkgs.lib.nixosSystem, apparently what nixos-rebuild also uses 
  getFlakeOutputs = npinsSource: (import sources.flake-compat { src = npinsSource; }).outputs;
  inputs = {
    matugen = getFlakeOutputs sources.matugen;
    #quickshell = getFlakeOutputs sources.quickshell;
    niri = getFlakeOutputs sources.niri;
    qtengine = getFlakeOutputs sources.qtengine;
  };
in {
  inherit inputs;
  inherit sources;
  scythe = nixosSystem {
    modules = [ ./hosts/scythe/configuration.nix ];
    specialArgs = {
      inherit inputs; # Flake inputs attrbute sets
      inherit sources; # Source input paths
    };
  };
}

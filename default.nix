let
  sources = import ./npins;
  nixpkgs = sources.nixpkgs;
  nixosSystem = import "${nixpkgs}/nixos/lib/eval-config.nix"; # Same thing as flake nixpkgs.lib.nixosSystem, apparently what nixos-rebuild also uses 
  getFlakeOutputs = npinsSource: (import sources.flake-compat { src = npinsSource; }).outputs;
  inputs = {
    #hjem = getFlakeOutputs sources.hjem;
    matugen = getFlakeOutputs sources.matugen;
    quickshell = getFlakeOutputs sources.quickshell;
    niri = getFlakeOutputs sources.niri;
  };
in {
  inherit inputs;
  scythe = nixosSystem {
    modules = [ ./hosts/scythe/configuration.nix ];
    specialArgs = {
      inherit inputs; # Flake inputs attrbute sets
      inherit sources; # Source input paths
    };
  };
}

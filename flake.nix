{
  description = "My NixOS and Homemanager config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";

  outputs = { self, nixpkgs }@attrs: {

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Can configure nixos system configuration directly here
     # modules =
     #   [ ({ pkgs, ... }: {
     #       boot.isContainer = true;

     #       # Let 'nixos-version --json' know about the Git revision
     #       # of this flake.
     #       system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

     #       # Network configuration.
     #       networking.useDHCP = false;
     #       networking.firewall.allowedTCPPorts = [ 80 ];

     #       # Enable a web server.
     #       services.httpd = {
     #         enable = true;
     #         adminAddr = "morty@example.org";
     #       };
     #     })
     #   ];

     # Or inport it here like this
     specialArgs = attrs;
     modules = [./nixos/configuration.nix];
    };

  };
}

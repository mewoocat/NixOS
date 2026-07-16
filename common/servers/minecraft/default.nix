{pkgs, inputs, ...}:{

  # Config using options from nixpkgs (doesn't appear to support mods)
  /*
  nixpkgs.config.allowUnfree = true;
  # Runs on port 25565 by default
  services.minecraft-server.enable = true;
  services.minecraft-server.eula = true;
  services.minecraft-server.openFirewall = true;
  services.minecraft-server.dataDir = "/var/lib/minecraft";
  */

  # Config using nix-minecraft flake
  # https://github.com/Infinidoge/nix-minecraft
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay # Adds minecraft related packages from nix-minecraft repo
  ];
  services.minecraft-servers = let

    # this requires a .mrpack file
    modpack = pkgs.fetchModrinthModpack {
      #url = "https://cdn.modrinth.com/data/PROJECT_ID/versions/VERSION_ID/modpack.mrpack";
      packHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      side = "server";
    };

    modpackLarionWorldGeneration = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/rctNbbuL/versions/ojlLh0uS/larion-fabric-1.21.1-4.3.0.jar";
      sha256 = "sha256-L3mIjV8sTjEqdGitACgtPAFVM2QWyfJSTkHTMrb3dwM=";
    };

    fabricApi = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/p96k10UR/fabric-api-0.119.4%2B1.21.4.jar";
      sha256 = "sha256-0YO6y4RRZ/CSZML5AyK37P/ogm3r2m9g5ZeIkmS+9K8=";
    };

  in {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/srv/minecraft"; # Each server will be under a sub dir here
    servers = {
      ServerA = {
        enable = true;
        autoStart = true;
        # See https://minecraft.wiki/w/Server.properties for list of available properties
        serverProperties = {
          server-port = 25565; # default
          difficulty = 3;
          gamemode = 1;
          max-players = 10;
          motd = "NixOS Minecraft server!";
          white-list = false;
          enable-rcon = false;
        };
        #package = pkgs.fabricServers.fabric-1_21_4; # somethings wrong with the fabric version
        #package = pkgs.vanillaServers.vanilla; # works
        #package = pkgs.fabricServers.fabric.override { jre_headless = pkgs.openjdk25_headless; }; # works
        # works
        # If getting weird runtime errors, try deleting the minecraft server folder 
        package = pkgs.fabricServers.fabric-1_21_4.override {
          loaderVersion = "0.19.3"; # Specific fabric loader version ... need to test if override is needed
        };
        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" [
            #modpackLarionWorldGeneration
            #fabricApi
          ];
        };
      };
    };

    # Shows better service logs
    managementSystem.systemd-socket.enable = true;
  };
}

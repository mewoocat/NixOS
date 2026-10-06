{
  pkgs,
  inputs,
  ...
}: {
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
    # Naming convention: name - MC Version - Mod Version
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

    modListCommand = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/Bx6i1J4x/versions/r9trhpT3/modscmd-fabric-1.0.2.jar";
      sha256 = "sha256-Rwpsy1/HSmCN+MkBttS1DIjkdZgt1YOOyKzOndmfDHw=";
    };
    # dependency of modListCommand
    mcPitanLib = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/uNRoUnGT/versions/1AfjWvTE/mcpitanlib-4.0.7-1.21.4-fabric.jar";
      sha256 = "sha256-vZiEass98s3zMr+uwcdNB+26Wni5+W5pPHcLLpMoKt4=";
    };

    terralith = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/MuJMtPGQ/Terralith_1.21.x_v2.5.8.jar";
      sha256 = "sha256-ADM6EwrDi3ucqTcACY1eAuBhK9wtNSKq2i825WAGIb8=";
    };

    # 26.2

    terralith-26_2-2_6_4 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/OxfI2n80/Terralith_26.2_v2.6.4.jar";
      sha256 = "sha256-2GfG80joacGeill56d0sRu0FjB7bRwkPaGPDLM5ISRc=";
    };
    lithostitched-26_2-1_8_0 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/XaDC71GB/versions/sGGUpIGT/lithostitched-1.8.0-fabric-26.2.jar";
      sha256 = "sha256-TXSo7CAjZXNSrgUfGmJwv/R0vzzEYBMQDv9fndu90CQ=";
    };

    better-nether-26_201_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/MpzVLzy5/versions/iBR9QMPF/better-nether-26.201.2.jar";
      sha256 = "sha256-q4tx8/9J3VZ2NR0zbcdr2xDqOcohAfyWP2dr8ZiPGjo=";
    };
    # deps
    fabricApi-26_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/ewUK83HI/fabric-api-0.161.0%2B26.2.jar";
      sha256 = "sha256-5bhYzrEykMJ04xy4iP9aGkDLkQZ+f/qwtbd1rsUeIWo=";
    };
    worldweaver-26_201_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/RiN8rDVs/versions/GHdiOIsp/worldweaver-26.201.2.jar";
      sha256 = "sha256-4ELsIBHRYT6vnn/D4nF58xsaG+cEtCcdA1WJppkUuKE=";
    };
    bclib-26_201_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/BgNRHReB/versions/7BfGRji6/bclib-26.201.2.jar";
      sha256 = "sha256-eXu4294MKCZdCMwxWBWH4sbrLzRKIM3hZU+4Gc2hGT0=";
    };

    famersDelight-26_1-3_6_26 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/7vxePowz/versions/RvMf1qzl/FarmersDelight-26.2-3.6.26%2Brefabricated.jar";
      sha256 = "sha256-FCoBZkl9gRyx/VUopi46C9HniFBq0nadMD0VnJvpHsI=";
    };

    friendsAndFoes-26_2-4_0_27 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/POQ2i9zu/versions/rJBCX3gG/friendsandfoes-fabric-4.0.27%2Bmc26.2.jar";
      sha256 = "sha256-lnkkoPmbAZ6l5P9JjbyYP+4Oym7gT7dagvpBJAsnuVw=";
    };

    resourcefulLib-5_0_4 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/G1hIVOrD/versions/4BbCbnE6/ResourcefulLib-5.0.4.jar";
      sha256 = "sha256-RmAoExYit/w9wcWuAxXYU2WqMSrpC7g2tI8YOOhYBWY=";
    };

    xareos-minimap-26_2-26_5_1 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/1bokaNcj/versions/VlMbRW2O/xaerominimap-fabric-26.2-26.5.1.jar";
      sha256 = "sha256-B18mKUfl5cAZLJw2Y5+mZyAMB40lfLZW3gtKPOLWUkA=";
    };

    # Spark - Performance Profiler
    spark-26_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/l6YH9Als/versions/e3hsPc1o/spark-1.10.187-fabric.jar";
      sha256 = "";
    };

    # Lithium - Server efficieny optimization
    lithium-26_2 = pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/f7vZ0VWU/lithium-fabric-0.25.3%2Bmc26.2.jar";
      sha256 = "";
    };
  in {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/srv/minecraft"; # Each server will be under a sub dir here
    servers = {
      ServerA = {
        enable = false;
        autoStart = true;
        # See https://minecraft.wiki/w/Server.properties for list of available properties
        serverProperties = {
          server-port = 25565; # default
          difficulty = 3;
          gamemode = 0; # survival
          cheats = true;
          max-players = 10;
          motd = "NixOS Minecraft server!";
          white-list = false;
          enable-rcon = false;
        };
        operators = {
          eXia_beep_boop = {
            uuid = "0b444121-e744-4c6b-a994-43d3b764e0ad";
            level = 4;
            bypassesPlayerLimit = true;
          };
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
            modpackLarionWorldGeneration
            fabricApi
            modListCommand
            mcPitanLib
            terralith
          ];
        };
      };

      ServerB = {
        enable = true;
        autoStart = true;
        # See https://minecraft.wiki/w/Server.properties for list of available properties
        serverProperties = {
          server-port = 25566; # default
          difficulty = 3;
          gamemode = 0; # survival
          cheats = true;
          max-players = 10;
          motd = "Shelby's desires";
          white-list = false;
          enable-rcon = false;
        };
        operators = {
          eXia_beep_boop = {
            uuid = "0b444121-e744-4c6b-a994-43d3b764e0ad";
            level = 4;
            bypassesPlayerLimit = true;
          };
        };
        package = pkgs.fabricServers.fabric-26_2.override {
          loaderVersion = "0.19.3";
          jre_headless = pkgs.openjdk25_headless; # fabric 26.2 needs jdk 25
        };
        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" [
            terralith-26_2-2_6_4
            lithostitched-26_2-1_8_0
            better-nether-26_201_2
            fabricApi-26_2
            worldweaver-26_201_2
            bclib-26_201_2
            famersDelight-26_1-3_6_26
            friendsAndFoes-26_2-4_0_27
            resourcefulLib-5_0_4
            xareos-minimap-26_2-26_5_1
          ];
        };
      };

      # 1.21.1
      ServerC = let
        fabricApi = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Mys3P7lK/fabric-api-0.116.17%2B1.21.1.jar";
          sha256 = "sha256-eaxEtAeArL2ISzTFC+HjmvaChH5fXLOx/d7qp2jc6AA=";
        };
        cobblemon = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/MdwFAVRL/versions/gBW3vLC7/Cobblemon-fabric-1.8.1%2B1.21.1.jar";
          sha256 = "sha256-TZC6Z3XjozKq2dXkmp9jZvlzs+GhLgAE0iziHGAO68U=";
        };
        terralith = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/eWDLFabb/Terralith_1.21.x_v2.6.2.jar";
          sha256 = "sha256-nNTUAv3g9SPltDCsj9R5zgWup6UP4MjCaQH192knIhQ=";
        };
        lithostitched = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/XaDC71GB/versions/eN30OQaU/lithostitched-1.8.0-fabric-21.1.jar";
          sha256 = "sha256-G7Xh8Tw5TntpS5S/+a8ktEnlGQeWUcoCdl2nreMHn/c=";
        };
        teletransportationAcceptTPA = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/6h6n9XJ9/versions/Si2A8zdz/tpa-1.3.1.jar";
          sha256 = "sha256-QDwF/l/Xba61rdWNdqn8+d6+yAlbTquw5cf/8q8iQ40=";
        };
        cobblemonAdditions = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/W2pr9jyL/versions/NVitD9gY/cobblemon-additions-4.3.0.jar";
          sha256 = "sha256-MzkWwtKmRpN5QuG0+p5+rw9/VG3D3A3vkMkLL/82MrM=";
        };
        cobbleDollars = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/s7N7AsqL/versions/NQdxKsW7/CobbleDollars-fabric-2.0.0%2BBeta-6.1%2B1.21.1.jar";
          sha256 = "sha256-oAdSPi3YxvR+3JFNM9Jq0KhgoBJAOOHsYwOlk6kZwbQ=";
        };
        radicalCobblemonTrainers = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/lRwTUnD7/versions/rgfBfnW9/rctmod-fabric-1.21.1-0.19.2-beta.jar";
          sha256 = "sha256-Lj0sYQEpAPz1qVfilnYmmVj6zKWT3rx6nglROFRqywo=";
        };
        forgeConfigAPIPort = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/ohNO6lps/versions/N5qzq0XV/ForgeConfigAPIPort-v21.1.6-1.21.1-Fabric.jar";
          sha256 = "sha256-LjqPDjvahafXInIOfOh5y9nQKNk5XG/CJNMps8mC2bE=";
        };
        radicalCobblemonTrainersAPI = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/CBfM2yw7/versions/bgmxNN26/rctapi-fabric-1.21.1-0.16.1-beta.jar";
          sha256 = "sha256-kT8SvHerQ81O6FIJsHjbSDWUkNFlQ2SLoJf6LnkQyE4=";
        };
        architecturyAPI = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/Pzc2FP5K/architectury-13.0.11-fabric.jar";
          sha256 = "sha256-qxfVx9jYyTzHE0N+1Cbw/w1vgCpI//DFeam9OqqDPv0=";
        };
        radGyms = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/eF8kqlHd/versions/jNLB4nS8/rad-gyms-fabric-0.5.0.jar";
          sha256 = "sha256-sUNcCq8+bbseVVxDUj7Les45YWeQy5IwW0YqU9Jzwx0=";
        };
        cobblemonPokeNav = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/bI8Nt3uA/versions/BV5KiAcY/cobblenav-fabric-2.4.1.jar";
          sha256 = "sha256-h+n2fKPJjkTt9ve2PQkqVZrfPeRzevYtZtTu4ru6g3w=";
        };
        cobblemonBattleMusic = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/n3D4BPgL/versions/fzLc8awA/blackwhite-battle-music-1.1.jar";
          sha256 = "sha256-imdCQ2jnGzRlGCOtyhuOJ3Af3WWwx7+R6P7zXu2bFnU=";
        };
        cobblemonIntros = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/gG3mz6AL/versions/FQY0xvNo/CobblemonIntros-1.0.0.jar";
          sha256 = "sha256-9DHUS8BM39WmG0NDrsk12tBzY4vfouMpGsEBg8Drz+I=";
        };
        cobblemonLegendaryMonuments = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/m6RyHSbV/versions/F6Ub0Gga/legendarymonuments-fabric-1.21.1-8.1-Love_for_All.jar";
          sha256 = "sha256-ZMBNsdl1fFLSzIBc3CQmiNuMPYN6F1AFk8UJW2Zng7M=";
        };
        accessories = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/jtmvUHXj/versions/Xlt4eWBe/accessories-fabric-1.1.0-beta.53%2B1.21.1.jar";
          sha256 = "sha256-Ueb21SyyUjGZrTblvASAIjD4aQTDWsPb825ZyGssMNE=";
        };
        chipped = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/BAscRYKm/versions/6h2mVZcb/chipped-fabric-1.21.1-4.0.2.jar";
          sha256 = "sha256-FyHJQ2X9jS08P9ysfvv9fmBdqn37itxMEmxbveKCDHk=";
        };
        resourcefulLib = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/G1hIVOrD/versions/Hf91FuVF/resourcefullib-fabric-1.21-3.0.12.jar";
          sha256 = "sha256-kwZMWv+Fv15jhUcPMR/Rx94XL1iwL++x0pINt2+M2LU=";
        };
        athena = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/b1ZV3DIJ/versions/JfyYsWKP/athena-fabric-1.21.1-4.0.6.jar";
          sha256 = "sha256-4XqthMaQrE5GMApBgLOuQHf/pPUm28gtEXr7v/Tug+Q=";
        };
        cobblemonMegaShowdown = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/SszvX85I/versions/TKdAixuR/mega_showdown-fabric-1.2.0%2B1.8.1%2B1.21.1-release.jar";
          sha256 = "sha256-1yQkO9/dEsJm3fX1+g3zbGinWSWPAVRp7RxAXzuiYac=";
        };
        owo-lib = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/ccKDOlHs/versions/m3XmDd8j/owo-lib-0.13.0-alpha.15%2B1.21.jar";
          sha256 = "sha256-vxT9hdPTYOXB+OTiKUqLLuXAuvfzeIFgRzttIX7zgW8=";
        };
        inmis = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/I0UYcPa0/versions/iE11BIfP/inmis-2.8.2-1.21.1.jar";
          sha256 = "sha256-/A/sKYFkmU7V9/VKh6raPS8fIbE1wu2zDpS6PQle8Dw=";
        };
        clothConfigAPI = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/9s6osm5g/versions/HpMb5wGb/cloth-config-15.0.140-fabric.jar";
          sha256 = "sha256-M4lOldo69ZAUs50SZYbVJB4H6jn4YYdj4w2rY3QF+V8=";
        };
        cobblemonCaptureXP = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/LBl4Qguc/versions/FOUiJc3h/capturexp-fabric-1.8.1-1.3.0.jar";
          sha256 = "sha256-yPmDx+mRYAc/wOpEOK6hwIxUXZlIn3VssbL14NACzJM=";
        };
        cobbleTimCore = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/lVP9aUaY/versions/lYFZ3a5r/timcore-fabric-1.8.1-1.33.2.jar";
          sha256 = "sha256-n1ZXuC+kSzOjf/IGp798Elo7obfIxHVmG5N4lcUiP0Q=";
        };
      in {
        enable = true;
        autoStart = true;
        # See https://minecraft.wiki/w/Server.properties for list of available properties
        serverProperties = {
          server-port = 25567; # default
          difficulty = 2; # normal
          gamemode = 0; # survival
          cheats = true;
          max-players = 10;
          motd = "nasty surprise";
          white-list = false;
          enable-rcon = false;
        };
        operators = {
          eXia_beep_boop = {
            uuid = "0b444121-e744-4c6b-a994-43d3b764e0ad";
            level = 4;
            bypassesPlayerLimit = true;
          };
        };
        package = pkgs.fabricServers.fabric-1_21_1.override {
          #loaderVersion = "";
          #jre_headless = pkgs.openjdk...;
        };
        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" [
            fabricApi
            terralith
            lithostitched
            teletransportationAcceptTPA

            # Cobblemon
            cobblemon
            cobblemonAdditions
            cobbleDollars
            radicalCobblemonTrainers
            forgeConfigAPIPort
            radicalCobblemonTrainersAPI
            architecturyAPI
            radGyms

            cobblemonPokeNav
            cobblemonBattleMusic
            cobblemonIntros
            cobblemonLegendaryMonuments
            accessories
            chipped
            resourcefulLib
            athena
            cobblemonMegaShowdown
            owo-lib
            inmis
            clothConfigAPI
            cobblemonCaptureXP
            cobbleTimCore
          ];
        };
      };
    };

    # Shows better service logs
    managementSystem.systemd-socket.enable = true;
  };

  # Extra hardening for server c which is defined using the nix-minecraft module here:
  # - https://github.com/Infinidoge/nix-minecraft/blob/master/modules/minecraft-servers.nix
  # See also:
  # - https://wiki.nixos.org/wiki/Systemd/Hardening
  # - https://notashelf.dev/posts/insecurities-remedies-i
  #
  # WARNING: If experiences strange errors with the server, try checking if hardening broke something.
  systemd.services.minecraft-server-ServerC = {
    serviceConfig = {
      ProtectSystem = "strict";
      RuntimeDirectory = "minecraft"; # Created under /run directory
      RootDirectory = "/run/minecraft";
      #StateDirectory = "minecraft";
      ReadWritePaths = "";
      BindReadOnlyPaths = [
        builtins.storeDir # Nix store
        "/etc/resolv.conf" # For DNS
      ];
      BindPaths = [
        "/srv/minecraft/"
        "/run/minecraft/"
      ];
      NoNewPrivileges = true;
      RemoveIPC = true;
    };
  };
}

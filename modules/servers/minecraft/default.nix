{...}:{
  nixpkgs.config.allowUnfree = true;
  # Runs on port 25565 by default
  services.minecraft-server.enable = true;
  services.minecraft-server.eula = true;
  services.minecraft-server.openFirewall = true;
}

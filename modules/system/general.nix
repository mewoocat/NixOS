{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  nix = {
    settings = {
      # Cachix for Hyprland
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      
      # Enable flakes
      experimental-features = ["nix-command" "flakes"];
    };

    # Garbage cleanup
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    settings.auto-optimise-store = true;
    optimise.automatic = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      #"electron-25.9.0"
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  # This appears broken
  #services.envfs.enable = true; # Populate /usr/bin with binaries

  programs.xfconf.enable = true;
  security.rtkit.enable = true; # rtkit is optional but recommended
  services.gvfs.enable = true; # File file manager func.

}

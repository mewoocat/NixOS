{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {

  imports = [
    inputs.agenix.nixosModules.default
  ];

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
    config.allowInsecure = true;
    # see?: https://discourse.nixos.org/t/permanently-enabling-unfree-packages-for-nix-profile-system-config-uses-flake/44394
    # this no work?
    config.permittedInsecurePackages = [
      #"electron-25.9.0"
      "electron-36.9.5"
      "qtwebengine-5.15.19" # idk what this is for
    ];
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default # Agenix cli client
    man-pages
  ];

  #services.envfs.enable = true; # Populate /usr/bin with binaries # This appears broken
  security.rtkit.enable = true; # rtkit is optional but recommended
  services.gvfs.enable = true; # File file manager func.
  services.pcscd.enable = true; # For hardware keys
  services.udev.packages = with pkgs; [
    #libfido2 # For hardware keys, not needed?
  ];

  programs.xfconf.enable = true;
}

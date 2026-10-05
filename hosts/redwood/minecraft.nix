{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
  };

  # Allow user to run container which allows for containers to be ran as a non root user
  # which improves security.
  users.users.minecraft = {
    isNormalUser = true;
    extraGroups = ["podman"];
  };

  environment.systemPackages = with pkgs; [
    podman-tui
  ];
}

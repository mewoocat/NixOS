{
  options,
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # This is a custom option
  username = "eXia";

  imports = [
    ../../modules/applications
    ../../modules/dev-environments
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eXia = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager" "docker" "vboxusers"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";
  #time.timeZone = "America/Denver";

  home-manager.users.${config.username} = {
    imports = [
      ./home.nix
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-29.4.6"
  ];
}

{
  pkgs,
  ...
}: {

  imports = [
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.iris= {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager" "docker" "vboxusers" "cdrom"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      vesktop
      microfetch
      prismlauncher
      spotify
      ungoogled-chromium
      freerdp xrdp
      globalprotect-openconnect
    ];
  };
  
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19" # For globalprotect-openconnect
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";
}

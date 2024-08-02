{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.username} = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = pkg: true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
    ];

    home.packages = with pkgs; [
      obsidian
    ];

    xdg.mime.enable = true;
    xdg.mimeApps.enable = true;
    xdg.desktopEntries = {
      obsidian = {
        name = "Obsidian :)";
        # Fix for gpu issues
        exec = "obsidian --disable-gpu %u";
        categories = ["Office"];
        comment = "Knowledge base";
        icon = "obsidian";
        mimeType = ["x-scheme-handler/obsidian"];
        type = "Application";
      };
    };
  };
}

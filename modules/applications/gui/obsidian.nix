{
  config,
  pkgs,
  ...
}: {

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = true;
  users.users.${config.username}.packages = with pkgs; [
    obsidian
  ];


  /*
  home-manager.users.${config.username} = {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # Fix for obsidian using electron 25 which is EOL
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
  */
}

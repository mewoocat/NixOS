{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.username} = {
    programs.gnome-terminal = {
      enable = false;
      showMenubar = false;
      profile."642ab23b-1a4b-488a-872d-f3eeb408ebeb" = {
        visibleName = "Default";
        default = true;
        font = "SpaceMono Nerd Font 10";
        transparencyPercent = 40;
      };
    };
  };
}

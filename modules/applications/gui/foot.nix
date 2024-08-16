{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.username} = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "SpaceMono Nerd Font:size=10";
          pad = "12x12";
        };
        colors = {
          #alpha = 0.78;
          alpha = 1;
        };
      };
    };
  };
}

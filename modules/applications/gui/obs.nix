{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.username} = {  
    programs.obs-studio = {
      enable = true;
      plugins = [pkgs.obs-studio-plugins.wlrobs];
    };
  };
}

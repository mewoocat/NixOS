{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.username} = {
    programs.librewolf = {
      enable = true;
    };
  };
}

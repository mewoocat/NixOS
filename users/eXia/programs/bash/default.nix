{
  config,
  pkgs,
  lib,
  ...
}: let 
  username = "eXia";
in
{
  hjem.users.${username} = {
    enable = true;
    files = {
      ".bashrc" = {
        source = ./.bashrc;
        clobber = true;
      };
    };
  };
}

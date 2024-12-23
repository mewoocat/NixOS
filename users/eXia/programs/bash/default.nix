{
  config,
  pkgs,
  lib,
  ...
}: let 
  username = "eXia";
in
{
  homes.${username} = {
    enable = true;
    files = {
      ".bashrc" = {
        source = ./.bashrc;
        clobber = true;
      };
    };
  };
}

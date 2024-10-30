# This directory contains all the default dynamic config files
# These are files that will be copied to ~/.config/leaf-de/ if they do not exist
# The purpose of these files is to dynamic reloading of certain config properties without requiring a rebuild
# For example, this could include user data such as pfp, location, monitor config, and colorscheme

{
  config,
  pkgs,
  ...
}: {
  imports = [

  ];
}

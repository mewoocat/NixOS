{
  config,
  pkgs,
  lib,
  ...
}: {
  # Custom user options
  options = {
    # Option declarations.
    # Declare what settings a user of this module module can set.
    # Usually this includes a global "enable" option which defaults to false.

    # Make option to set username
    username = lib.mkOption {
      type = lib.types.str;
      default = "please-change-me";
    };

    userModules = lib.mkOption {
      type = lib.types.listOf lib.types.submodule;
      default = [];
    };

  };

  imports = config.userModules;
  /*
  [
    lib.evalModules { 
      modules = config.userModules; 
    }
  ];
  */

  config = {
    # Option definitions.
    # Define what other settings, services and resources should be active.
    # Usually these depend on whether a user of this module chose to "enable" it
    # using the "option" above.
    # Options for modules imported in "imports" can be set here.

    userModules = [
      #../applications/tui/btop
    ];

  };
}

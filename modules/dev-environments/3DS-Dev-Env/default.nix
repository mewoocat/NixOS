{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  devkitA64 = inputs.devkitnix.packages.x86_64-linux.devkitA64;
  devkitpro = pkgs.mkShell {
    buildInputs = [
      devkitA64
    ];
    shellHook = ''
      export DEVKITPRO=${devkitA64}
    '';
  };
  devkitpro2 = pkgs.writeShellScriptBin "devkitpro" "${devkitA64}";
in{
  home-manager.users.${config.username} = {
    home.packages = [
      #devkitpro 
      devkitpro2
    ];
  };
}

{pkgs, inputs, ...} : {
  imports = [
    inputs.qtengine.nixosModules.default
  ];
  programs.qtengine = {
    enable = false;
    config = {
      theme = {
        # Note that this file apparently affect the colors of icons
        colorScheme = "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";
        #colorScheme = "${leaf-dir}/qtengine.colors";
        iconTheme = "kora";
        style = "darkly";
        font = {
          family = "Rubik";
          size = 11;
          weight = -1;
        };
        fontFixed = {
          family = "SpaceMono Nerd Font";
          size = 11;
          weight = -1;
        };
      };
      misc = {
        menusHaveIcons = true;
      };
    };
  };
}

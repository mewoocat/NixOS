{
  config,
  pkgs,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "SpaceMono Nerd Font:size=10";
        pad = "12x12";
      };
      colors-dark = {
        alpha = 0.80;
        #alpha = 1;
      };
    };
  };
}

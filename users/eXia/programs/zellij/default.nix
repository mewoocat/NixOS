{
  config,
  pkgs,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      copy_command = "wl-copy";
      pane_frames = false;
      simplified_ui = true;
      ui.pane_frames = {
        hide_session_name = true;
        rounded_corners = true;
      };

      layout_dir = "${./layouts}";
      #default_layout = "compact";
      default_layout = "normal";

      theme = "default";
      # Need to declaritivley create this dir
      theme_dir = "${config.home.homeDirectory}/.config/zellij/themes";
      themes = {
        gruvbox-dark = {
          fg = "#D5C4A1";
          bg = "#282828";
          black = "#3C3836";
          red = "#CC241D";
          green = "#98971A";
          yellow = "#D79921";
          blue = "#3C8588";
          magenta = "#B16286";
          cyan = "#689D6A";
          white = "#FBF1C7";
          orange = "#D65D0E";
        };
      };
    };
  };
}

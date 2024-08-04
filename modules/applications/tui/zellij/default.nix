{
  config,
  pkgs,
  ...
}: {

  home-manager.users.${config.username} = {

    # For setting the zellij tab name to current dir
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        # From: https://www.reddit.com/r/zellij/comments/10skez0/does_zellij_support_changing_tabs_name_according/
        zellij_tab_name_update() {
            if [[ -n $ZELLIJ ]]; then
                local current_dir=$PWD
                if [[ $current_dir == $HOME ]]; then
                    current_dir="~"
                else
                    current_dir=''\${current_dir##*/}
                fi
                command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
            fi
        }

        zellij_tab_name_update
        # Modify "cd" to update tab name each time
        function cd(){
          builtin cd "$@"
          zellij_tab_name_update
        }
      '';
    };


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
        theme_dir = "/home/${config.username}/.config/zellij/themes";
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
  };
}

{config, pkgs, lib, ...}:
# Does this need to be a function?
{
  # export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
  programs.bash = {
    enable = true;
    bashrcExtra = ''

      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      # Prompt
      #######################
      RESET="\[\017\]"
      NORMAL="\[\033[0m\]"
      RED="\[\033[31;1m\]"
      YELLOW="\[\033[33;1m\]"
      WHITE="\[\033[37;1m\]"
      SMILEY="''${WHITE}:)''${NORMAL}"
      FROWNY="''${RED}:(''${NORMAL}"
      SELECT="if [ \$? = 0 ]; then echo \"''${SMILEY}\"; else echo \"''${FROWNY}\"; fi"

      # Throw it all together 
      PS1="''${RESET}''${YELLOW}\h''${RED}@''${YELLOW}\u''${NORMAL} [\T] \W \`''${SELECT}\` ''${YELLOW}>''${NORMAL} "
      #######################

      ([ -f ~/.cache/wal/sequences ] && cat ~/.cache/wal/sequences &)
      # To add support for TTYs this line can be optionally added.
      #source ~/.cache/wal/colors-tty.sh


      # BEGIN_KITTY_SHELL_INTEGRATION
      if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
      # END_KITTY_SHELL_INTEGRATION

      
      # Aliases
      ########################################################################################################
      alias vi='nvim'
      alias rebuild='sudo nixos-rebuild switch --flake ~/NixOS#$(hostname)'
      alias startup=~/NixOS/scripts/startup.sh
      alias fastfetch="fastfetch --logo none"
      alias ff="fastfetch --logo none"
      alias ls='ls -altr --color=auto'
      alias rm='rm -I'

      # Fixes kitty ssh issue
      alias ssh="kitty +kitten ssh"

      #alias tmux='tmux -2' # Makes tmux assume 256 bit colors which fixed color issue with vim within tmux

      # Misc
      ########################################################################################################
      # Fix for gsettings no schema
      export GSETTINGS_SCHEMA_DIR=${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;

      eval "$(zoxide init bash)"


      if [[ -f ~/startup.sh ]]; then
        ~/startup.sh
      fi

      # Set terminal with wallust colors
      cat ~/.cache/wallust/sequences
    '';
  };
}

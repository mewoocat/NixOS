{config, pkgs, lib, ...}:
# Does this need to be a function?
{
  # export GSETTINGS_SCHEMA_DIR=/nix/store/hqd68mpllad47hjnhgnqr6zqcrsi3dsz-gnome-gsettings-overrides/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      #. ~/.bashrc_backup -> this is what's below (testing)
      # Note: two single quotes escapes $ { ... }
      ######################################
      #
      # ~/.bashrc
      #

      # If not running interactively, don't do anything
      [[ $- != *i* ]] && return

      alias ls='ls -altr --color=auto'
      #alias rm='rm -i'
      alias hi='echo "hiiiiii"'

      #PS1='\e[\u@\h \W]\$ \e[m'
      export PS1="\e[0;31m[\u@\h \W]\$ \e[m "

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

      # Import colorscheme from 'wal' asynchronously
      # &   # Run the process in the background.
      # ( ) # Hide shell job control messages.
      # Not supported in the "fish" shell.
      #(cat ~/.cache/wal/sequences &)

      # Alternative (blocks terminal for 0-3ms)
      #cat ~/.cache/wal/sequences
      #


      ([ -f ~/.cache/wal/sequences ] && cat ~/.cache/wal/sequences &)

      # To add support for TTYs this line can be optionally added.
      #source ~/.cache/wal/colors-tty.sh


      # BEGIN_KITTY_SHELL_INTEGRATION
      if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
      # END_KITTY_SHELL_INTEGRATION

      export QSYS_ROOTDIR="/hom/ghost/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/21.1/quartus/sopc_builder/bin"
      export PATH="/home/ghost/.local/bin":$PATH

      alias lock='/home/exia/myNixOSConfig/home-manager/scripts/lockScreen.sh'
      alias vi='nvim'
      alias tmux='tmux -2' # Makes tmux assume 256 bit colors which fixed color issue with vim within tmux
      alias rebuild='sudo nixos-rebuild switch --flake ~/NixOS#$(hostname)'

      # Fixes kitty ssh issue
      alias ssh="kitty +kitten ssh"

      # [ -f ~/.fzf.bash ] && source ~/.fzf.bash

      # Use bash-completion, if available
      #[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
      #    . /usr/share/bash-completion/bash_completion

      alias rta="~/Projects/Scripts/RandomTerminalArt.sh"

      alias f="neowofetch --backend off"

      # Run initial programs
      #neofetch


      ######################################
      # Fix for gsettings no schema
      export GSETTINGS_SCHEMA_DIR=${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;


      eval "$(zoxide init bash)"


      if [[ -f ~/startup.sh ]]; then
        ./startup.sh
      fi

    '';
  };
}


# What is this even doing?
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
#######################
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[31;1m\]"
YELLOW="\[\033[33;1m\]"
WHITE="\[\033[37;1m\]"
SMILEY="${WHITE}:)${NORMAL}"
FROWNY="${RED}:(${NORMAL}"
SELECT="if [ \$? = 0 ]; then echo \"${SMILEY}\"; else echo \"${FROWNY}\"; fi"

# Throw it all together
PS1="${RESET}${YELLOW}\h${RED}@${YELLOW}\u${NORMAL} [\T] \W \`${SELECT}\` ${YELLOW}>${NORMAL} "
#######################


# Aliases
########################################################################################################
alias vi='nvim'
alias rebuild='nixos-rebuild --use-remote-sudo switch --flake ~/NixOS#$(hostname)'
alias ls='ls -altr --color=auto'
alias rm='rm -I'

# Misc
########################################################################################################
# Fix for gsettings no schema
#export GSETTINGS_SCHEMA_DIR=${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;

eval "$(zoxide init bash)"

if [[ -f ~/startup.sh ]]; then
~/startup.sh
fi

# Set terminal with wallust colors
cat ~/.cache/wallust/sequences

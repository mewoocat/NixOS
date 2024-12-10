{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      

      # Aliases
      ########################################################################################################
      alias vi='nvim'
      alias rebuild='nixos-rebuild --use-remote-sudo switch --flake ~/NixOS#$(hostname)'
      alias ls='ls -altr --color=auto'
      alias rm='rm -I'

      # Misc
      ########################################################################################################
      # Fix for gsettings no schema
      export GSETTINGS_SCHEMA_DIR=${pkgs.gnome.nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/;

      eval "$(zoxide init bash)"

      if [[ -f ~/startup.sh ]]; then

      fi

      # Set terminal with wallust colors
      cat ~/.cache/wallust/sequences
    '';
  };
}

{ config, pkgs, lib, ... }: let
    #flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

    #hyprland = (import flake-compat {
    # src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
    #}).defaultNix;

      # Shell scripts
  #what = pkgs.writeShellScriptBin "lockScreen2" ''exec ${pkgs.gtklock}/bin/gtklock'';
  what = import ./scripts/lockScreen.nix { inherit pkgs; };
  
   huh = pkgs.writeShellScriptBin "lockScreen3" ''
        echo "what";
        ${pkgs.gtklock}/bin/gtklock;
    '';

in

{
  imports = [
    #hyprland.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "exia";
  home.homeDirectory = "/home/exia";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    (pkgs.writeShellScriptBin "my-hello" ''
        ${pkgs.gtklock}/bin/gtklock
    '')

    git
    neovim
    vim
    kitty

    firefox
    obsidian
    cinnamon.nemo
    webcord
    obs-studio
    onlyoffice-bin

    acpi
    lm_sensors
    neofetch
    htop
    light
    bluez
    swww
    wirelesstools
    pipewire
    pulseaudio
    alsa-utils
    pamixer
    pavucontrol
    gtklock
    swayidle
    wl-clipboard
    glib
    shotman

    pywal

    #killall?
    jaq
    gojq
    socat
    ripgrep
    jq
    bc

    liberation_ttf
    arkpandora_ttf

    apple-cursor

    gnome.gucharmap
    rofi
    wpgtk
    lxappearance-gtk2
    themechanger
    
    hyfetch

    vlc

    what
    huh

  ];




  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

   ".config/kitty".source = ./kitty; 

   ## Need to manually create .local/bin? 
   #".local/bin/lockScreen.sh" = {
   #  executable = true;
   #  recursive = true;
   #  source = ./scripts/lockScreen.sh;
   #};

  };


#    lockScreenVar = stdenv.mkDerivation rec {
#      name = "lockScreenName";
#      # disable unpackPhase etc
#      phases = "buildPhase";
#      builder = ./scripts/lockScreen.sh;
#      nativeBuildInputs = [ gtklock ];
#      PATH = lib.makeBinPath nativeBuildInputs;
#    };



  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/exia/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    # Set wayland flags
    # Doesn't work?
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER="wayland";
    QT_QPA_PLATFORM="wayland;xcb";
  };



    programs.eww = {
        enable = true;
        configDir = ./eww;
        package = pkgs.eww-wayland;
    };





gtk = {
      enable = true;
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      cursorTheme = {
        name = "macOS-BigSur";
        package = pkgs.apple-cursor;
        size = 24;
      };
      iconTheme = {
      	name = "kora";
        package = pkgs.kora-icon-theme;
      };
    };

    # start swayidle as part of hyprland, not sway
    systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];

    services.swayidle = {
      enable = true; 
      package = pkgs.swayidle;
      #systemdTarget = "basic.target";
      #extraArgs = [ pkgs ];
      events = [
        #{ event = "before-sleep"; command = "${pkgs.gtklock}/bin/gtklock"; }
        #{ event = "before-sleep"; command = "${pkgs.gtklock}/bin/gtklock -t \"%l:%M %P\""; }
        { event = "before-sleep"; command = "${pkgs.my-hello}/bin/my-hello"; }

      ];
    };


    services.udiskie = {
        enable = true;
        automount = true;
        tray = "never";
    };

    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.hidpi = true;
        extraConfig = ''


########################################################################################
AUTOGENERATED HYPR CONFIG.
PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
########################################################################################

#
# Please note not all available settings / options are set here.
# For a full list, see the wiki
#

#autogenerated = 1 # remove this line to remove the warning

# Monitors
# See https://wiki.hyprland.org/Configuring/Monitors/
#
# Main display only
#monitor=eDP-1, 2560x1440@60, 0x0, 1.30
#monitor=eDP-1, 1920x1080@60, 0x0, 1.0

# 144hz monitor
monitor=eDP-1, 2560x1440@60, 100x1080, 1.45 
#monitor=eDP-1, 1920x1080@60, 100x1080, 1.0 
monitor=DP-1, 1920x1080@144, 0x0, 1.0 # On top
#monitor=eDP-1,disable

# 240hz monitor only
#monitor=eDP-1,disable
#monitor=DP-1, 1920x1080@240, 0x0, 1.0 # On top

# For 4k screens
#monitor=eDP-1, 2560x1440@60, 1080x2160, 1.0 
#monitor=DP-1,3840x2160@60,0x0,1

# For 4k monitor only
#monitor=eDP-1,disable
#monitor=DP-1,3840x2160@60,0x0,1

# Rotating
#monitor=eDP-1, 2560x1440@60, 1080x2160, 1.5, transform, 1 

#monitor=DP-1, 1920x1080@60, 0x0, 1.0 # On top

#monitor=,preferred,auto,auto,mirror,eDP-1

#monitor=DP-1,highres,auto,1


workspace=2,monitor:eDP-1,name:2,gapsin:5,gapsout:20
workspace=3,monitor:eDP-1,name:3,gapsin:5,gapsout:20
workspace=4,monitor:eDP-1,name:4,gapsin:5,gapsout:20
workspace=5,monitor:eDP-1,name:5,gapsin:5,gapsout:20
workspace=1,monitor:eDP-1,name:1,gapsin:5,gapsout:20


workspace=6,monitor:DP-1,gapsin:20,gapsout:20
workspace=7,monitor:DP-1,gapsin:20,gapsout:20
workspace=8,monitor:DP-1,gapsin:20,gapsout:20
workspace=9,monitor:DP-1,gapsin:20,gapsout:20
workspace=10,monitor:DP-1,gapsin:20,gapsout:20


# Disables middle mouse paste for gtk apps
#  gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
#  firefox
#  middlemouse.paste: false in about:config

# Turn off title bar buttons
exec-once=gsettings set org.gnome.desktop.wm.preferences button-layout appmenu

# This script could be causing the crashing issue
exec-once=~/.config/hypr/scripts/handle_monitor_connect.sh

# This script could be causing the crashing issue
#exec=~/.config/hypr/scripts/handle_monitor_connect.sh


# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox

# Start wallpaper daemon
# Set wallpaper on start
#exec = sleep 1 && swww init && swww img ~/.config/wallpaper.jpg
exec-once = sleep 1 && swww init && ${config.home.homeDirectory}/.scripts/theme.sh -w

exec = "${config.home.homeDirectory}/.config/eww/scripts/launchEww.sh"
exec-once = dunst


exec-once=/usr/lib/polkit-kde-authentication-agent-1
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
#exec-once=/home/ghost/.config/hypr/scripts/xdg.sh

# Disables touchscreen
#exec-once=evtest --grab /dev/input/event7 >> /dev/null

# Set GTK cursor in nwg-look
# Set Hyprland cursors
#exec-once=hyprctl setcursor macOS-Monterey 28
#exec-once=hyprctl setcursor Adwaita 28
exec-once=hyprctl setcursor macOS-BigSur 24

#exec-once=gsettings set org.gnome.desktop.interface cursor-theme macOS-Monterey
# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Disables middle mouse paste
#exec=wl-paste -p --watch wl-copy -pc   # Causes text selection in gtk to stop working
#bind = , mouse:274, exec, ;

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options = ctrl:nocaps
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = yes
        scroll_factor = 0.25
        drag_lock = true
    }

    sensitivity = -0.2 # -1.0 - 1.0, 0 means no modification.

    touchdevice {
     
    }
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 3
    col.active_border = rgba(595959aa) #rgba(331199aa) 45deg
    col.inactive_border = rgba(0a0a0aaa)
    col.group_border = rgba(0a0a0aaa)
    col.group_border_active = rgba(595959aa)

    #groupbar_gradients = false

    layout = dwindle
    #damage_tracking = full
}

# Blurs eww bar
blurls=gtk-layer-shell
# Removes sharp corner from bluring on rounded corners
layerrule = ignorezero, gtk-layer-shell
#layerrule = ignorealpha 0, gtk-layer-shell

#layerrule = blur, gtk-layer-shell
#layerrule = ignorealpha 0.5, gtk-layer-shell



# Blur rofi
layerrule = blur,rofi
#layerrule = rounding 10,rofi



decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 14
    multisample_edges = true
    blur = yes
    blur_size = 4
    blur_passes = 4
    blur_new_optimizations = true

    drop_shadow = true
    shadow_range = 12
    shadow_render_power = 20
    col.shadow = rgba(000000cd)

}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    #bezier=overshot,0.05,0.9,0.1,1.1

    animation = windows, 1, 4, myBezier, 
    animation = windowsOut, 1, 4, default, popin 80%
    animation = border, 1, 4, default
    animation = borderangle, 1, 4, default
    animation = fade, 1, 4, default
    animation = workspaces, 1, 2, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = on
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic mouse V1 {
    sensitivity = -0.5
}

# Not working
device:elan-touchscreen {
    enabled = false 
}

misc {
   vfr = true
   disable_splash_rendering	= true
}


# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, RETURN, exec, kitty
bind = $mainMod_SHIFT, Q, killactive 
bind = $mainMod_SHIFT, Delete, exit, 
bind = $mainMod, E, exec, nemo
bind = $mainMod, V, togglefloating, 
bind = $mainMod, R, exec, /home/ghost/git/anyrun/target/release/anyrun
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, X, exec, rofi -show drun
#bind = $mainMod, X, exec, nwggrid
bind = $mainMod, F, fullscreen
#bind = ,Print, exec, sway-screenshot -m region --clipboard-only
bind = ,Print, exec, shotman -c region
bind = $mainMod, T, togglegroup	
bind = $mainMod, TAB, changegroupactive, f	
bind = $mainMod_SHIFT, TAB, changegroupactive, b
bind = $mainMod_SHIFT, T, moveoutofgroup	
bind = $mainMod, M, exec, ~/.config/eww/scripts/toggleSystemMenu.sh

bind = $mainMod, L, exec, ~/.scripts/theme.sh -l
bind = $mainMod, D, exec, ~/.scripts/theme.sh -d
bind = $mainMod_SHIFT, L, exec, ~/.scripts/theme.sh -G -l
bind = $mainMod_SHIFT, D, exec, ~/.scripts/theme.sh -G -d

bind = $mainMod_SHIFT, R, exec, hyprctl reload

# Disable middle mouse paste
#bind = , mouse:274, exec, ;

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

bind = $mainMod SHIFT,S,movetoworkspace,special
bind = $mainMod,S,togglespecialworkspace

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod SHIFT, mouse:272, resizewindow

# Brightness
# sleep is needed so that killall has a chance to run and not kill the script
# On the first killall run the script won't be running so because of the && the script will fail to run
# Probably a better way to do this.
bindle = , XF86MonBrightnessUP, exec, light -A 10 & eww update osd_mode="brightness" & killall brightnessOSD.sh & sleep 0.01 && ~/.config/hypr/scripts/brightnessOSD.sh
bindle = , XF86MonBrightnessDown, exec, light -U 10 & eww update osd_mode="brightness" & killall brightnessOSD.sh & sleep 0.01 && ~/.config/hypr/scripts/brightnessOSD.sh

# Volume
bindle = , XF86AudioRaiseVolume, exec, pamixer -i 10 & eww update osd_mode="volume" & killall brightnessOSD.sh & sleep 0.01 && ~/.config/hypr/scripts/brightnessOSD.sh 
bindle = , XF86AudioLowerVolume, exec, pamixer -d 10 & eww update osd_mode="volume" & killall brightnessOSD.sh & sleep 0.01 && ~/.config/hypr/scripts/brightnessOSD.sh

# For screen sharing?
exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        '';
      };


}

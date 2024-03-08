{config, pkgs, lib, inputs, ...}:
{
  # Window manager
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      #inputs.hycov.packages.${pkgs.system}.hycov
    ];
    
    extraConfig = ''


        #source = ~/.cache/hypr/monitors.conf




        # Monitors
        monitor=DP-3,1920x1080@144,0x0,1
        monitor=DVI-D-1,preferred,1920x0,1
        monitor=,preferred,auto,1


        # Workspace rules
        workspace = 1, monitor:DP-3, default:true
        workspace = 2, monitor:DP-3
        workspace = 3, monitor:DP-3
        workspace = 4, monitor:DP-3, gapsin:0, gapsout:0, rounding:0
        workspace = 5, monitor:DP-3
        workspace = 6, monitor:DVI-D-1, default:true
        workspace = 7, monitor:DVI-D-1
        workspace = 8, monitor:DVI-D-1
        workspace = 9, monitor:DVI-D-1
        workspace = 10, monitor:DVI-D-1


        # Plugins
        #plugin = /nix/store/m8v9nhx6r7zzqxkhzv5jkzi7ws42hiim-hyprbars-0.1/lib/libhyprbars.so 

        # Autostart programs

        # Reloads swayidle when Hyprland is started since it cannot properly load when system boots as wayland is started manually
        #exec-once = systemctl --user restart swayidle

        # Handle monitors being connected
        exec-once=~/.config/hypr/scripts/handle_monitor_connect.sh

        # Start wallpaper daemon and set wallpaper on start
        exec-once = sleep 1 && swww init && ../theme_bird/theme.sh -w

        # Launch ags
        exec-once = ags

        # Authentication
        exec-once=/usr/lib/polkit-kde-authentication-agent-1

        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        exec-once=nextcloud


        # Set GTK cursor in nwg-look
        # Set Hyprland cursors
        exec-once=hyprctl setcursor macOS-BigSur 24

        #exec-once=gsettings set org.gnome.desktop.interface cursor-theme macOS-Monterey
        # Source a file (multi-file configs)
        # source = ~/.config/hypr/myColors.conf

        # Disables middle mouse paste
        #exec=wl-paste -p --watch wl-copy -pc   # Causes text selection in gtk to stop working
        #bind = , mouse:274, exec, ;
        #
        # Disables middle mouse paste for gtk apps
        #  gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
        #  firefox
        #  middlemouse.paste: false in about:config

        # Turn off title bar buttons
        exec-once=gsettings set org.gnome.desktop.wm.preferences button-layout appmenu

        # Nvidia Env variables
        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = WLR_NO_HARDWARE_CURSORS,1



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
            gaps_in = 5
            gaps_out = 20
            gaps_workspaces	= 40
            border_size = 3
            col.active_border = rgba(595959aa) #rgba(331199aa) 45deg
            col.inactive_border = rgba(0a0a0aaa)
            layout = dwindle
            #damage_tracking = full
            resize_on_border = true
        }

        misc {
        force_default_wallpaper = 0
        disable_hyprland_logo = true
        }

        # Pseudo tiles all windows?
        # Having these on causes (XWayland?) appplications to open dialog boxes in center of screen, e.g. gimp
        #windowrule=pseudo,.*?
        #windowrule=center,.*?

        # Blurs anyrun
        blurls=anyrun
        layerrule = ignorealpha 0.5, anyrun # This only blurs the search box portion instead the whole layer which covers the whole screen

        # Blurs these ags windows
        blurls=applauncher
        layerrule = ignorezero, applauncher # Removes sharp corner from bluring on rounded corners

        blurls=ControlPanel
        layerrule = ignorezero, ControlPanel # Removes sharp corner from bluring on rounded corners

        blurls=bar-0
        blurls=bar-1
        blurls=bar-2
        blurls=bar-3
        blurls=bar-4

        blurls=ActivityCenter
        layerrule = ignorezero, ActivityCenter # Removes sharp corner from bluring on rounded corners

        blurls=Dock
        layerrule = ignorezero, Dock # Removes sharp corner from bluring on rounded corners



        decoration {
            rounding = 14
            blur {
            enabled = true
            size = 4
            passes = 4
            new_optimizations = true
            }

            drop_shadow = true
            shadow_range = 12
            shadow_render_power = 20
            col.shadow = rgba(000000cd)

        }

        animations {
            enabled = yes
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
        bind = $mainMod, E, exec, thunar
        bind = $mainMod, V, togglefloating, 
        bind = $mainMod, P, pseudo, # dwindle
        bind = $mainMod, J, togglesplit, # dwindle
        bind = $mainMod, F, fullscreen
        bind = ,Print, exec, grimshot copy area
        bind = $mainMod, T, togglegroup	
        bind = $mainMod, TAB, changegroupactive, f	
        bind = $mainMod_SHIFT, TAB, changegroupactive, b
        bind = $mainMod_SHIFT, T, moveoutofgroup	
        bind = $mainMod, X, exec, ags -t applauncher
        bind = $mainMod, M, exec, ags -t ControlPanel
        bind = $mainMod, D, exec, ags -t Dock
        bind = $mainMod, A, exec, ags -t ActivityCenter
        bind = $mainMod, L, exec, wallpaper=$(cat ~/.config/wallpaper) && gtklock -i -t "%l:%M %P" -b $wallpaper; 
        bind = $mainMod, G, exec, ~/.config/hypr/scripts/toggleGaps.sh

        bind = $mainMod, F1, exec, ~/.config/hypr/scripts/gamemode.sh # Toggle gamemode / animations
        bind = $mainMod, F2, exec, pkill ags && ags


        #bind = $mainMod_SHIFT, R, exec, hyprctl reload

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
        bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
        bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
        bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
        bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
        bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
        bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
        bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
        bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
        bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
        bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

        # Special workspaces
        bind = $mainMod SHIFT,S,movetoworkspace,special
        bind = $mainMod,S,togglespecialworkspace
        bind = $mainMod Shift,W,movetoworkspace,e+0         # Moves selected client to current ws

        # Scroll through existing workspaces with mainMod + scroll
        bind = $mainMod, mouse_down, workspace, e+1
        bind = $mainMod, mouse_up, workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod SHIFT, mouse:272, resizewindow

        # Brightness
        bindle = , XF86MonBrightnessUP, exec, light -A 5 
        bindle = , XF86MonBrightnessDown, exec, light -U 5

        # Volume
        bindle = , XF86AudioRaiseVolume, exec, pamixer -i 5 
        bindle = , XF86AudioLowerVolume, exec, pamixer -d 5

        # For screen sharing?
        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP


    '';
    
  };
}
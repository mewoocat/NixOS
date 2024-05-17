{ config, pkgs, lib, inputs, ... }: let
in

{
  imports = [
    inputs.ags.homeManagerModules.default
    
    ./programs/default.nix
    ./programs/nvim
    ./packages.nix
    ./programs/firefox
    ./programs/bash.nix
    ./programs/hyprland/hyprland.nix
 ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eXia";
  home.homeDirectory = "/home/eXia";

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


  # Activation scripts 
  home.activation = {
    #Read home manager on home.activation 
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

   ".config/kitty".source = ./programs/kitty; 
   ".config/ags".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/ags";
   ".config/tmux".source = ./programs/tmux;
   ".config/matugen".source = ./programs/matugen;
   ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/programs/btop";
   ".config/retroarch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixOS/home-manager/programs/retroarch";

   # Themes
   ".local/share/themes/adw-gtk3".source = ./programs/theme/adw-gtk3;
   ".local/share/themes/adw-gtk3-dark".source = ./programs/theme/adw-gtk3-dark;

  };

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
    DEFAULT_BROWSER = "firefox"; # Doesn't seem to work
    
    #QT_QPA_PLATFORMTHEME="gnome"; # For qgnomeplatform-qt6
  };



  # Services

  # start as part of hyprland, not sway
  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  services.swayidle = {
    enable = true; 
    package = pkgs.swayidle;
    #systemdTarget = "basic.target";
    #extraArgs = [ pkgs ];
    events = let
      lock = (pkgs.writeShellScriptBin "my-hello" ''
          wallpaper=$(${pkgs.coreutils}/bin/cat ~/.config/wallpaper);
          ${pkgs.gtklock}/bin/gtklock -i -t "%l:%M %P" -b $wallpaper;
      '');

    in
    [
      { event = "before-sleep"; command = "${lock}/bin/my-hello"; }

    ];
  };

  services.udiskie = {
      enable = true;
      automount = true;
      tray = "never";
  };

  # Doesn't spawn systray so i dont like
  #services.nextcloud-client.enable = true;
  #services.nextcloud-client.startInBackground = true;



  # Theme 

  # GTK Config
  gtk = {
    enable = true;
    #theme = {
    #  #name = "adw-gtk3";  
    #  name = "WhiteSur-Dark";
    #  package = pkgs.whitesur-gtk-theme;
    #};
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

  # QT Config (BROKEN)
  qt = {
    enable = true;
    #style.name = "kvantum";

    platformTheme = "qtct";
  };


  # XDG
  xdg.desktopEntries = {
    obsidian = {
      name = "Obsidian :)";
      exec = "obsidian --disable-gpu %u";
      categories = [ "Office" ];
      comment = "Knowledge base";
      icon = "obsidian";
      mimeType = [ "x-scheme-handler/obsidian" ];
      type = "Application";
    };

    webcord = {
      name = "Webcord :)";
      exec = "webcord --disable-gpu";
      categories = [ "Network" "InstantMessaging" ];
      comment = "A Discord and SpaceBar electron-based client implemented without Discord API";
      icon = "webcord";
      type = "Application";
    };

    vesktop = {
      name = "Vesktop :)";
      exec = "vesktop --disable-gpu";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      icon = "vesktop";
      type = "Application";
    };
  };

  # These are the applications that were in .config/mimeapps.list before HM started managing them
  /*
    [Default Applications]
    image/jpeg=org.gnome.eog.desktop
    application/x-zerosize=org.gnome.eog.desktop
    image/png=org.gnome.eog.desktop
    application/zip=org.freedesktop.Xwayland.desktop
    text/plain=l3afpad.desktop

    [Added Associations]
    image/jpeg=code.desktop;gimp.desktop;org.gnome.eog.desktop;
    video/mp4=org.gnome.gThumb.desktop;vlc.desktop;org.gnome.eog.desktop;
    application/x-zerosize=gimp.desktop;org.gnome.eog.desktop;
    application/x-theme=l3afpad.desktop;
    image/png=org.gnome.eog.desktop;
    application/zip=org.freedesktop.Xwayland.desktop;
    text/markdown=l3afpad.desktop;
    text/plain=l3afpad.desktop;

  */

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  # Not needed?
  /*
  xdg.mimeApps.associations.added = {
    "text/html" = "firefox";
    "x-scheme-handler/http" = "firefox";
    "x-scheme-handler/https" = "firefox";
    "x-scheme-handler/about" = "firefox";
    "x-scheme-handler/unknown" = "firefox";
  };
  */
  xdg.mimeApps.defaultApplications = {
    /*
    # Set default browser 
    # Not sure if this is working
    "text/html" = ["firefox.desktop"];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
    "x-scheme-handler/about" = ["firefox.desktop"];
    "x-scheme-handler/unknown" = ["firefox.desktop"];
    "application/x-extension-htm" = ["firefox.desktop"];
    "application/x-extension-html" = ["firefox.desktop"];
    "application/x-extension-shtml" = ["firefox.desktop"];
    "application/x-extension-xht" = ["firefox.desktop"];
    "application/x-extension-xhtml" = ["firefox.desktop"];
    "application/xhtml+xml" = ["firefox.desktop"];
    "x-scheme-handler/ftp" = ["firefox.desktop"];
    */


    "image/png" = ["org.gnome.gThumb.desktop"];
    "image/jpeg" = ["org.gnome.gThumb.desktop"];
    "application/pdf" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = ["firefox.desktop"];
    "x-scheme-handler/https" = ["firefox.desktop"];
  };

}

{config, pkgs, inputs, ...} : let 

  # GTK theme
  # TODO: pin the version of adw-gtk3
  adw-gtk3-override = let 
    colorsImportText = "@import \"/home/${config.username}/.config/gtk-3.0/colors.css\";";
    lineToInsertAfter = "125";
  in pkgs.adw-gtk3.overrideAttrs {
    postInstall = ''
      # Modify the gtk css to override specified colors
      # This is needed since ~/.config/gtk-3.0/gtk.css can't be hot reloaded.  If we want to dynamically change
      # the colors of the theme without requiring a restart of any running apps, the theme itself will need to
      # import the dynamic colors
      sed -i '${lineToInsertAfter}a ${colorsImportText}' $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk.css
      sed -i '${lineToInsertAfter}a ${colorsImportText}' $out/share/themes/adw-gtk3-dark/gtk-3.0/gtk-dark.css

      sed -i '${lineToInsertAfter}a ${colorsImportText}' $out/share/themes/adw-gtk3/gtk-3.0/gtk.css
      sed -i '${lineToInsertAfter}a ${colorsImportText}' $out/share/themes/adw-gtk3/gtk-3.0/gtk-dark.css
      #The gtk-dark.css in adw-gtk3 is the exact same as both the gtk.css and gtk-dark.css for adw-gtk3-dark
    '';
  };

in {

  imports = [
  ];

  # This can be used to dynamically set gtk options
  # gsettings set org.gnome.desktop.interface icon-theme whitesur-gtk-theme
  # gsettings set org.gnome.desktop.interface cursor-theme <name>
  # gsettings set org.gnome.desktop.interface cursor-size 24

  users.users.${config.username}.packages = with pkgs; [
    # GTK Themes
    #adw-gtk3 # Main GTK theme
    adw-gtk3-override
    whitesur-gtk-theme
    orchis-theme
    shades-of-gray-theme
    nwg-look
  ];

  hjem.users.${config.username} = {
    clobberFiles = true;
    files = {

      ".config/gtk-3.0/settings.ini" = {
        text = ''
          [Settings]
          gtk-cursor-theme-name=capitaine-cursors
          gtk-cursor-theme-size=24
          gtk-icon-theme-name=kora
        '';
      };

      # Note that this file is not dynamically loaded by gtk3 apps
      # Apps have to be restarted for any changes here to take effect
      #
      # So the only way I see for hot reloading the colors on a gtk theme is to modify
      # the theme itself to import it colors dynamically.  This seems to get reloaded
      # on the fly when reapplying the theme.
      /*
      ".config/gtk-3.0/gtk.css" = {
        # This imports the colors generated from matugen
        text = ''
          @import 'colors.css';
        '';
      };
      */

      ".config/gtk-4.0/gtk.css" = {
        # This imports the colors generated from matugen
        text = ''
          @import 'colors.css';
        '';
      };
    };
  };

}

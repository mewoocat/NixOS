#!/bin/sh




function usage(){
    echo " Inputs"
    echo "   Wallpaper"
    echo "   Color theme file"
    echo "   Dark / Light"
    echo ""
    echo " Effects"
    echo "   Upate Hyprland colors"
    echo "   Update AGS colors"
    echo "   Update terminal colors"
    echo "   Update GTK colors"
    echo "   Set wallpaper"
    echo ""
    echo " Features"
    echo "   Set wallpaper       "
    echo "   Set colorscheme"
    echo ""
    echo "   Usage"
    echo "       theme.sh [options] [mode] wallpaper"
    echo "   Options"
    echo "       -c | --color-scheme     (If no color scheme is provided, one will be generated from the wallpaper)"
    echo "   Modes"
    echo "       -d | --dark             (Default)"
    echo "       -l | --light"
}

#walColors="Path/to/color/file/generated/by/matugen"
gtkThemeLight="adw-gtk3"
gtkThemeDark="adw-gtk3-dark"

# TODO: Check if qt5ct and qt6ct dir's exist in .config and if not, run and kill each to generate the configs 
# This is needed to be able to modify the color setting
# Also need to generate the config file with the colorscheme variable
# This normally would get generated when the first theme is applied


# Usage: setWallpaper $wallpaper
function setWallpaper(){
    swww img -t "simple" --transition-step 255 $1;          # Set wallpaper
    cp $1 ~/.cache/wallpaper;                               # Cache wallpaper

}

# Set QT theme
# Takes in a mode (light/dark)
function setQtTheme(){
    mode=$1
    qtTheme=""

    if [[ $mode == "light" ]];
    then
        qtTheme="airy"
    else
        qtTheme="darker"
    fi

    # Set QT theme
    # For the line(s) in the file that contain "color_scheme_path=" replace text between "colors/" and ".conf" with "darker"
    sed -i "/color_scheme_path=/ s/colors\/.*\.conf/colors\/$qtTheme\.conf/g" ~/.config/qt5ct/qt5ct.conf ~/.config/qt6ct/qt6ct.conf 
}

function setColors(){
    wallpaper=$1
    mode=$2
    colorscheme=$3

 
    setQtTheme $mode

    # Determine mode (light/dark)
    if [[ $mode == "dark" ]];
    then
        gtkTheme=$gtkThemeDark
        mode=""
    else
        #gtkTheme=$gtkThemeLight
        gtkTheme=$gtkThemeDark # Testing using same gtk theme for light and dark
        mode="-l"
    fi

    # Debugging...
    echo "gtk = $gtkTheme"
    echo "mode = $mode"

    # Process base16 colorscheme
    # Wallust sets terminal colorscheme and generates templates
    #
    # Generate colorscheme from wallpaper
    if [[ $colorscheme == "" ]]; then
        ./wallust-3.0.0-beta-x86_64-unknown-linux-musl-with-assets/wallust run $wallpaper
    # Use provided colorscheme
    else
        ./wallust-3.0.0-beta-x86_64-unknown-linux-musl-with-assets/wallust cs $colorscheme  
    fi

    # Reload GTK theme
    gsettings set org.gnome.desktop.interface gtk-theme phocus
    gsettings set org.gnome.desktop.interface gtk-theme $gtkTheme   # Reload GTK theme
}

function setWallpaperTheme(){
    wallpaper=$1
    mode=$2 # Light/Dark
    colorscheme=$3

    # Set wallpaper
    setWallpaper $wallpaper

    # Set colorscheme
    setColors $wallpaper $mode $colorscheme


}


# Initial values
mode=""
colorscheme=""

# get input flags
while getopts l:d:c:h flag
do
    case "${flag}" in
    
        l) wallpaper=${OPTARG}; mode="light" ;;

        d) wallpaper=${OPTARG}; mode="dark" ;;

        c) colorscheme=${OPTARG} ;;

        # Set wallpaper only
        #w)  ;;

        h) usage ;;

    esac
done

setWallpaperTheme $wallpaper $mode $colorscheme


exit 0





























# Legacy
#########################################################################################################################

    # Generate matugen colors from wallpaper
    #matugen image $wallpaper --mode "$mode" --show-colors --contrast 0 -t scheme-rainbow
    #matugen color hex $accentColor --mode "$mode" --contrast 0 -t scheme-rainbow # --show-colors
    #matuBG=$(cat ~/.config/ags/Style/_colors.scss | grep "\$surface:" | cut -d ' ' -f2 | head -c -2)
#########################################################################################################################

# from https://github.com/AmadeusWM/dotfiles-hyprland/blob/main/themes/apatheia/scripts/wallpaper
# swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
#
# From chatGPT
lighten_color() {
  # Convert the input hex code to RGB values
  hex=$1
  amount=$2

  r=$(printf '0x%s' ${hex:0:2})
  g=$(printf '0x%s' ${hex:2:2})
  b=$(printf '0x%s' ${hex:4:2})

  # Add a small amount to each RGB value to lighten the color
  r=$((r + $amount))
  g=$((g + $amount))
  b=$((b + $amount))

  # Make sure the RGB values stay within the valid range of 0-255
  r=$((r > 255 ? 255 : r))
  g=$((g > 255 ? 255 : g))
  b=$((b > 255 ? 255 : b))

  # Convert the new RGB values back to a hex code
  printf '#%02x%02x%02x\n' $r $g $b
}

# From chatGPT
darken_color() {
  # Convert the input hex code to RGB values
  hex=$1
  amount=$2

  r=$(printf '0x%s' ${hex:0:2})
  g=$(printf '0x%s' ${hex:2:2})
  b=$(printf '0x%s' ${hex:4:2})

  # Add a small amount to each RGB value to lighten the color
  r=$((r - $amount))
  g=$((g - $amount))
  b=$((b - $amount))

  # Make sure the RGB values stay within the valid range of 0-255
  r=$((r < 0 ? 0 : r))
  g=$((g < 0 ? 0 : g))
  b=$((b < 0 ? 0 : b))

  # Convert the new RGB values back to a hex code
  printf '#%02x%02x%02x\n' $r $g $b
}


# Notes:    Add new color called iconBG where is a darken/lightend version of fg
function setagsColorsWal(){
    mode=$1

    # sed command from https://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file
    #echo "\$bg: $(sed '1q;d' ~/.cache/wal/colors);" > ~/.config/ags/_colors.scss;
    #echo "\$fg: $(sed '16q;d' ~/.cache/wal/colors);" >> ~/.config/ags/_colors.scss;

    # New color file in different dir since .config/ags is read only
    echo "\$bg: $(sed '1q;d' ~/.cache/wal/colors);" > ~/.config/ags/Style/_colors.scss;
    echo "\$fg: $(sed '16q;d' ~/.cache/wal/colors);" >> ~/.config/ags/Style/_colors.scss;

    # Get theme variables 
    bg=$(sed '1q;d' ~/.cache/wal/colors | cut -c 2-)
    fg=$(sed '16q;d' ~/.cache/wal/colors | cut -c 2-)
    echo "bg $bg fg $fg"

    if [ $mode == "light" ]; then
        echo "\$bg_alt: $(darken_color $bg 40);" >> ~/.config/ags/Style/_colors.scss;
        echo "\$fg_alt: $(darken_color $bg 100);" >> ~/.config/ags/Style/_colors.scss;
    fi

    if [ $mode == "dark" ]; then
        echo "\$bg_alt: $(lighten_color $bg 40);" >> ~/.config/ags/Style/_colors.scss;
        echo "\$fg_alt: $(lighten_color $bg 100);" >> ~/.config/ags/Style/_colors.scss;
    fi

    echo "\$color1: $(sed '2q;d' ~/.cache/wal/colors);" >> ~/.config/ags/Style/_colors.scss;
    echo "\$color2: $(sed '3q;d' ~/.cache/wal/colors);" >> ~/.config/ags/Style/_colors.scss;
    echo "\$color3: $(sed '4q;d' ~/.cache/wal/colors);" >> ~/.config/ags/Style/_colors.scss;
    echo "\$color4: $(sed '5q;d' ~/.cache/wal/colors);" >> ~/.config/ags/Style/_colors.scss;

}

function setGtkColors(){

    path="/home/ghost/.themes/default/gtk-3.0/pywal-colors.css"

    # sed command from https://stackoverflow.com/questions/6022384/bash-tool-to-get-nth-line-from-a-file
    echo "@define-color bg $(sed '1q;d' ~/.cache/wal/colors);" > $path;
    echo "@define-color fg $(sed '16q;d' ~/.cache/wal/colors);" >> $path;
    
    # Get theme variables 
    bg=$(sed '1q;d' ~/.cache/wal/colors | cut -c 2-)
    fg=$(sed '16q;d' ~/.cache/wal/colors | cut -c 2-)

}


##################################################################################################
# End of legacy config

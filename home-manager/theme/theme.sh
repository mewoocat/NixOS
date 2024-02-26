#!/bin/sh




function usage(){
    echo " Inputs"
    echo "   Wallpaper"
    echo "   Color theme file"
    echo "   Dark / Light"
    echo ""
    echo " Options"
    echo "   "
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
    echo "       theme.sh [inputs] [options]"
    echo "   Inputs"
    echo "       -w | --wallpaper         "
    echo "       -c | --color-scheme     (If no color scheme is provided, one will be generated from the wallpaper)"
    echo "   Options"
    echo "       -d | --dark             (Default)"
    echo "       -l | --light"
}

#walColors="Path/to/color/file/generated/by/matugen"
gtkThemeLight="adw-gtk3"
gtkThemeDark="adw-gtk3-dark"


# Usage: setWallpaper $wallpaper
function setWallpaper(){
    swww img -t "simple" --transition-step 255 $1;          # Set wallpaper
    echo $1 > ~/.config/wallpaper;                          # Cache path to wallpaper
}


function setColors(){
    wallpaper=$1
    mode=$2

    if [[ $mode == "dark" ]];
    then
        gtkTheme=$gtkThemeDark
        walMode=""
    else
        gtkTheme=$gtkThemeLight
        walMode="-l"
    fi

    # Responsible for:
    #   GTK
    #   AGS
    #   Wal
    matugen image $wallpaper --mode "$mode" -t scheme-fruit-salad --show-colors

    # Debugging...
    echo "gtk = $gtkTheme"
    echo "mode = $mode"

    #gsettings set org.gnome.desktop.interface gtk-theme phocus
    gsettings set org.gnome.desktop.interface gtk-theme $gtkTheme   # Reload GTK theme
    #gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' && gsettings set org.gnome.desktop.interface color-scheme 'default'
    #gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    # AGS *should* auto detect the changes to it's color file

    # Responsible for:
    #   Kitty
    #   VSCode
    wal $walMode -n -i $wallpaper                                               # Set wal theme from matugen

}

function setWallpaperTheme(){
    wallpaper=$1
    mode=$2 # Light/Dark
    echo "mode = $mode aaaa"
    # Set wallpaper
    setWallpaper $wallpaper
    # Set colorscheme
    setColors $wallpaper $mode
}

# get input flags
while getopts l:d:h flag
do
    case "${flag}" in
    
        l) setWallpaperTheme ${OPTARG} "light" ;;

        d) setWallpaperTheme ${OPTARG} "dark" ;;

        # Set wallpaper only
        #w)  ;;

        h) usage ;;

    esac
done


exit 0




# Legacy
#########################################################################################################################

# from https://github.com/AmadeusWM/dotfiles-hyprland/blob/main/themes/apatheia/scripts/wallpaper
# swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
#
# Set kitty color scheme from file
# kitty @ set-colors -A ~/.config/kitty/current-theme.conf

wallpaper=$(cat $HOME/.cache/wal/wal)
wallpaper_path="$HOME/.cache/wal/wal"
theme_path="$HOME/.cache/wal/colors"

theme_colors_light="base16-irblack"
theme_colors_dark="base16-irblack"

gtk_light_theme="Mojave-Light"
gtk_dark_theme="Mojave-Dark"


theme=false;

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



function setLight(){
    wal -l --theme $theme_colors_light; 
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_light_theme;
    swww img $wallpaper_light;
    setagsColors light;
    echo $wallpaper_light > ~/.config/wallpaper;
}

function setDark(){
    wal --theme $theme_colors_dark;
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_dark_theme;
    #swww img $wallpaper_dark --transition-type outer;
    swww img $wallpaper_dark
    echo "\$color1: $(sed '2q;d' ~/.cache/wal/colors);" >> ~/.config/ags/_colors.scss;
    setagsColors dark;
    echo $wallpaper_dark > ~/.config/wallpaper;
}

function setWallpaperDark(){
    bgBlack=$2
    if [[ $bgBlack == true ]]; then
        wal -i $1 -b 000000;
    else
        #wal --backend colorz -i $1;
        wal --saturate 1.0 -i $1;
    fi
    setGtkColors
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_dark_theme;
    setagsColors dark;
    setWallpaper $1;
}

function setWallpaperLight(){
    wal -l -i $1;
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_light_theme;
    setagsColors light;
    setWallpaper $1
}

theme=false
bgBlack=false




# get input flags
while getopts W:i:bwldt:B:TL:D:Gx flag
do
    case "${flag}" in
        
        # Set wallpaper path in a file for compatibility between file types
        i) swww img ${OPTARG} ; echo "${OPTARG}" > ~/.config/wallpaper ;;

		# set wallpaper and theme with black bg
        b) bgBlack=true ;;
		
		# set wallpaper only
        w) currentWallpaper=$(cat ~/.config/wallpaper) && swww img "$currentWallpaper" ; theme=false ;;
        # w) > $wallpaper_path && echo "$(pwd)/${OPTARG}" >> $wallpaper_path ; theme=false ;;
        #
        # w) setWallpaperDark ${OPTARG} ;;
		
		# set theme to light
        l) setLight;;

		# set theme to dark
        d) setDark;; 	

        L) setWallpaperLight ${OPTARG} ;;

        D) setWallpaperDark ${OPTARG} $bgBlack;;

		# set theme only
		t) wal --theme ${OPTARG} > /dev/null ; theme=true ;;

        # set theme only and black background
        B) wal -b 000000 --theme ${OPTARG} > /dev/null ; theme=true ;;

        T) toggleTheme ;;
        
        # Set gtk theme from current pywal theme
        G) theme=true ;; 

        x) setRofiColors ;;
		
    esac
done

currentWallpaper=$(cat ~/.config/wallpaper)


# From https://www.reddit.com/r/swaywm/comments/gx1rbf/fancy_custom_swaylock_background_image/
#convert -filter Gaussian -resize 20% -blur 0x2.5 -resize 500% $currentWallpaper ~/.config/lockscreen.png
#convert $currentWallpaper -filter Gaussian -blur 0x8 ~/.config/lockscreen.png


if [ $theme == true ]; then
	# sets gtk theme colors
    #oomox-cli /opt/oomox/scripted_colors/xresources/xresources-reverse > /dev/null
	#oomox-cli /opt/oomox/scripted_colors/xresources/xresources-reverse-materia > /dev/null
	# reloads gtk theme
    #gsettings set org.gnome.desktop.interface gtk-theme "oomox-xresources-reverse"
	#killall xsettingsd > /dev/null 2>&1
	#timeout 1 xsettingsd -c .config/xsettingsd/xsettingsd.conf > /dev/null 2>&1
    
    setGtkColors
    gsettings set org.gnome.desktop.interface gtk-theme "default"

fi
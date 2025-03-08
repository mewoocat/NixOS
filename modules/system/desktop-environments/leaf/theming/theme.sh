#!/bin/sh

LEAF_CONFIG_DIR=~/.config/leaf-de

themeDir="$LEAF_CONFIG_DIR/theme"
presetDir="$LEAF_CONFIG_DIR/theme/presets"
currentThemePath="$LEAF_CONFIG_DIR/theme/current-theme.json"
recentThemesPath="$LEAF_CONFIG_DIR/theme/recent-themes.json"

# Create directories and files if they do not exist
mkdir -p $themeDir
mkdir -p $presetDir
if [ ! -f $currentThemePath ]; then
    echo "null" > $currentThemePath  
fi
if [ ! -f $recentThemesPath ]; then
    # Make empty json array
    echo "[]" > $recentThemesPath
fi

gtkThemeLight="adw-gtk3" # Just using non modified since the adw-gtk3-leaf repo hasn't added variable support for the light theme yet
#gtkThemeLight="adw-gtk3-leaf"
gtkThemeDark="adw-gtk3-leaf-dark"

# Globals variables
wallpaper=""
colorscheme=""
colorschemePath=""
mode="dark" # Light/Dark
createPreset=false
activatePreset=false
presetName="default"
themeOutputPath=""
jsonTheme="{}" # JSON string object of a theme

function usage(){
    echo "
    Usage
        theme.sh <param> <arg> <Options>
    Params
        -w | --wallpaper <path-to-wallpaper>    Set wallpaper
        -c | --colorscheme <colorscheme-name>   (If no color scheme is provided, one will be 
                                                generated from the wallpaper)
        -p | --pallets                          Select one of the wallust pallets (Defaults to dark)
        #-d | --dark                             Set a dark colorscheme (Default)
        #-l | --light                            Set a light colorscheme
        -g | --generate-preset                  Generate a preset based on the current theme 
                                                being set
        -a | --activate-preset <preset-name>    Activate an existing preset
        -L |                                    Activate the default light preset
        -D |                                    Activate the default dark preset
           | --set-as-default                   Sets theme as default light/dark
        -n | --name                             Set a name when generating a preset
        #-G | --get-active-theme                
        #-m | --get-current-mode                 Returns either "light" or "dark" given the current mode
    Options
        -h | --help                             Print this message

    Examples
        ./theme.sh -h
    "
}

function setWallpaper(){
    echo "INFO: setWallpaper()"
    swww img -t "simple" --transition-step 255 "$wallpaper";          # Set wallpaper
    cp $wallpaper "$HOME/.cache/wallpaper";                               # Cache wallpaper
}

# Set QT theme
# Takes in a mode (light/dark)
# TODO: Check if qt5ct and qt6ct dir's exist in .config and if not, run and kill each to generate the configs 
# This is needed to be able to modify the color setting
# Also need to generate the config file with the colorscheme variable
# This normally would get generated when the first theme is applied
function setQtTheme(){

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
    setQtTheme $mode

    # Determine mode (light/dark)
    if [[ $mode == *"light"* ]];
    then
        gtkTheme=$gtkThemeLight
    else
        gtkTheme=$gtkThemeDark
    fi

    # Debugging...
    echo "gtk = $gtkTheme"
    echo "mode = $mode"

    # Process base16 colorscheme
    # Wallust sets terminal colorscheme and generates templates
    #
    # Generate colorscheme from wallpaper
    if [[ $colorscheme == "" ]]; then
        wallust run $wallpaper -p $mode
    # Use provided colorscheme
    else
        colorschemePath="$HOME/.config/wallust/pywal-colors/$mode/$colorscheme.json"
        echo "colorschemePath = $colorschemePath"
        wallust cs $colorschemePath
    fi

    # Reload GTK theme
    gsettings set org.gnome.desktop.interface gtk-theme phocus
    gsettings set org.gnome.desktop.interface gtk-theme $gtkTheme   # Reload GTK theme
    # TODO: Probably also should set the color-scheme prefernce so none gtk apps get the memo
    #gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # Kill and restart GTK 4 apps
    # Have to kill not close in order for theme to change
    #pkill gnome-calendar
    #pkill nautilus 
    #gnome-calendar 1> /dev/null 2> /dev/null &
    #nautilus 1> /dev/null 2> /dev/null &
}

function setTheme(){

    echo "setTheme wallpaper = $wallpaper"

    # Set wallpaper
    if [[ "$wallpaper" != "" ]]; then
        setWallpaper
    fi

    # Set colorscheme
    setColors

    # Set theme as active by creating a current-theme.json file in ~/.config/leaf/theme
    themeOutputPath=$currentThemePath
    echo $themeOutputPath
    generatePreset

    addThemeToRecents
}

# Sets theme from JSON string object
setThemeFromJson(){

    echo "jsonTheme = $jsonTheme"

    wallpaper=$(echo $jsonTheme | jq -r .wallpaper) || (echo "Error reading JSON theme"; exit 1)
    colorscheme=$(echo "$jsonTheme" | jq -r .colorscheme) || (echo "Error reading JSON theme"; exit 1)
    mode=$(echo "$jsonTheme" | jq -r .mode) || (echo "Error reading JSON theme"; exit 1)

    echo "color = $colorscheme"

    setTheme

    exit 0;
}

function generatePreset(){
    echo "Creating preset..."
    echo "Name: $presetName"
    echo "Wallpaper: $wallpaper"
    echo "colorscheme: $colorscheme"
    echo "colorschemePath: $colorschemePath"

    # Use the wallust debug option to determine the values needed to find the path to a wallust colorscheme generated from a wallpaper
    #
    # Output preset information to json file 

    echo "Outputting preset as json"
    echo -e "{\n\t\"name\": \"$presetName\",\n\t\"mode\": \"$mode\",\n\t\"wallpaper\": \"$wallpaper\",\n\t\"colorscheme\": \"$colorscheme\",\n\t\"colorschemePath\": \"$colorschemePath\"\n}" > "$themeOutputPath"

}

# Echos path current theme .json
getActiveTheme(){
    echo "hello"
}

addThemeToRecents(){
    # Get recent themes
    #local json=$(cat $recentThemesPath)
    local currentTheme=$(cat $currentThemePath | jq '.')
    echo "Current theme:"
    echo $currentTheme

    # If theme is already in recents then move it to the front of the list

    # Check if theme to be added already exists
    # Returns null if it doesn't exist, returns the index in the array if it does exist
    local existingThemeIndex=$(cat $recentThemesPath | jq ". | index($currentTheme)") 
    echo $existingThemeIndex
    local recentThemesModified="null"

    # If the theme being set doesn't exist in the recent themes
    if [[ $existingThemeIndex == "null" ]]; then
        echo "Theme not in recents" 
        # Move themes over and replace the first one with the new theme
        recentThemesModified=$(cat $recentThemesPath | jq ".[4] = .[3] | .[3] = .[2] | .[2] = .[1] | .[1] = .[0] | .[0] = $currentTheme" )
    else
        echo "Theme in recents"
        # Creates a new json array by moving the existing theme to the front and moves everything before it down 1
        recentThemesModified=$(cat $recentThemesPath | jq "[.[$existingThemeIndex]] + .[0:$existingThemeIndex] + .[$existingThemeIndex + 1:]")
    fi

    # Overwrite the existing recent-themes.json
    printf "Recent themes modified = \n $recentThemesModified\n"
    printf "$recentThemesModified" > $recentThemesPath
    
}

function activatePreset(){
    local presetPath="$presetDir/$presetName.json"
    echo "presetPath = $presetPath" 

    # Check if preset exists
    if [[ ! -f "$presetPath" ]]; then
        echo "ERROR: Preset doesn't exist"
        exit 2
    fi

    wallpaper=$(cat "$presetPath" | jq -r .wallpaper)
    colorscheme=$(cat "$presetPath" | jq -r .colorscheme)
    mode=$(cat "$presetPath" | jq -r .mode)
    echo "preset wallpaper = $wallpaper"
    echo "preset colorscheme = $colorscheme"

    setTheme
}

# Get input flags
while getopts w:c:p:hga:A:n:DL flag
do
    case "${flag}" in
        w) wallpaper=${OPTARG}; ;;
        c) colorscheme=${OPTARG} ;;
        p) mode=${OPTARG} ;;
        g) createPreset=true ;;
        a) presetName=${OPTARG}; activatePreset=true ;;
        A) jsonTheme=${OPTARG}; setThemeFromJson; exit 0 ;;
        n) presetName=${OPTARG} ;;
        D) presetName="default-dark"; activatePreset; exit 0 ;; 
        L) presetName="default-light"; activatePreset; exit 0 ;; 
        #G) ; exit 0 ;;
        h) usage; exit 0 ;;

    esac
done

echo "colorscheme = $colorscheme"
echo "wallpaper = $wallpaper"
echo "mode = $mode"
echo "activatePreset = $activatePreset"


# Verify inputs
if [[ "$colorscheme" == "" && "$wallpaper" == "" && "$activatePreset" == false  ]]; then
    echo -e "ERROR: Invalid inputs"
    echo "A colorscheme, wallpaper, or preset must be specified"
    usage
    exit 1
fi

if [[ "$activatePreset" == true ]]; then
    activatePreset
    exit 0
fi

setTheme

if [[ "$createPreset" == true ]]; then 
    themeOutputPath="$presetDir/$presetName.json"
    generatePreset
fi

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

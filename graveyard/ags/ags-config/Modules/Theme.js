import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import GdkPixbuf from 'gi://GdkPixbuf'
import GLib from 'gi://GLib'
import Gtk from 'gi://Gtk'

import * as Global from '../Global.js'
import * as Common from '../Lib/Common.js'
import * as Log from '../Lib/Log.js'

import icons from '../icons.js';

////////////////////////////////////////////////////////////////////////////////////////////////////
// Globals
////////////////////////////////////////////////////////////////////////////////////////////////////
const themeDir = `${GLib.get_home_dir()}/.config/leaf-de/theme/`
const recentThemesPath = `${themeDir}/recent-themes.json`
const currentThemePath = `${themeDir}/current-theme.json`

const recentThemesJson = Variable(Common.ReadJSONFile(recentThemesPath))
const currentThemeJson = Variable(Common.ReadJSONFile(currentThemePath))
//const themeState = Variable(Common.ReadJSONFile(currentThemeJson)?.mode)

const themeState = Variable(null)


const recentThemesMonitor = Utils.monitorFile(recentThemesPath, (file, event) => {
    const json = Common.ReadJSONFile(file.get_path())
    if (json == null) { 
        return
    }
    recentThemesJson.value = json
})
const currentThemeMonitor = Utils.monitorFile(currentThemePath, (file, event) => {
    const json = Common.ReadJSONFile(file.get_path())
    if (json == null) { 
        return
    }
    currentThemeJson.value = json
})

////////////////////////////////////////////////////////////////////////////////////////////////////
// Helper functions
////////////////////////////////////////////////////////////////////////////////////////////////////

// Returns a list of the recent themes as widgets given the recent-themes.json as input
const GenerateRecentThemeWidgets = (themesJson) => {
    let themesList = []
    for (let key in themesJson){
        const theme = themesJson[key]
        const widget = ThemeSelectionButton(theme)
        if (widget != null){
            themesList.push(widget)
        }
    } 
    return themesList
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Widgets
////////////////////////////////////////////////////////////////////////////////////////////////////
export const ThemePanelButton = (w, h) => Widget.Button({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_primary_click: () => { 
        Global.ControlPanelTab.setValue("theme")
    },
    child: Widget.Icon({
        icon: icons.theme,
        size: 22,
    })
})

const ThemeSelectionButton = (theme) => {

    // Error checking
    if (theme == null || theme.colorscheme == ""){
        Log.Error("Error processing theme")
        return null
    }

    let wallpaperImage = theme.wallpaper

    // Getting the colorsceheme
    const colorschemeJson = Common.ReadJSONFile((theme.colorschemePath))
    if (colorschemeJson === null) {
        Log.Error("Colorscheme file could not be read, skipping creating widget for theme.")
        return null
    }

    // Generating colorscheme widget
    const colorGrid = Global.Grid()
    let colors = colorschemeJson["colors"]

    // Add all colors
    /*
    let colorNum = 0
    for (let key in colors){
        let color = colors[key]
        print("Color = " + color)
        let colorWidget = Widget.Box({
            css: `
                background-color: ${color};
                min-width: 1em;
                min-height: 1em;
                border-radius: 100%;
                margin: 0.2em;
            `,
        })
        let col = colorNum < 8 ? colorNum + 1 : colorNum + 1 - 8
        let row = colorNum < 8 ? 1 : 2
        print(`row = ${row} | col = ${col}`)
        // Usage: Grid.attach(widget, columnNum, rowNum, widthNum, heighNum) 
        colorGrid.attach(colorWidget, col, row, 1, 1)
        colorNum++
    }
    */

    // Add colors 1-7 to grid
    for (let i = 1; i < 8; i++){ 
        let color = colors[`color${i}`]
        let colorWidget = Widget.Box({
            css: `
                background-color: ${color};
                min-width: 1em;
                min-height: 1em;
                border-radius: 100%;
                margin: 0.2em;
            `,
        })
        colorGrid.attach(colorWidget, i, 1, 1, 1)
    }

    let wallpaperImageThumbnail

    // Try to load the image
    try {
        Log.Info(`Loading image from ${wallpaperImage} ...`)

        // Load image, crop to 16:9, and scale down
        const wallpaper = GdkPixbuf.Pixbuf.new_from_file(wallpaperImage)
        const targetWidth = 180
        let width = wallpaper.get_width()
        let height = wallpaper.get_height()
        let xOrigin = 0
        let yOrigin = 0
        const aspectRatio = width / height
        // If relative width is greater
        if (aspectRatio > (16 / 9)) {
            // Adjust width to match
            const adjustedWidth = Math.floor(height * (16 / 9))
            xOrigin = Math.floor((width - adjustedWidth) / 2)
            width = adjustedWidth
        }
        // If relative height is greater
        else if (aspectRatio < (16 / 9)) {
            // Adjust height to match
            const adjustedHeight = Math.floor(width * (9 / 16))
            yOrigin = Math.floor((height - adjustedHeight) / 2)
            height = adjustedHeight
        }
        const wallpaperCropped = wallpaper.new_subpixbuf(xOrigin, yOrigin, width, height)
        const wallpaperScaled = wallpaperCropped.scale_simple(targetWidth, targetWidth * (9 / 16), GdkPixbuf.InterpType.BILINEAR)
        wallpaperImageThumbnail = wallpaperScaled

    }
    catch (err){
        Log.Error(err)
        Log.Error("Image load failed, using fallback")
        wallpaperImageThumbnail = icons.invalidWallpaper 
    }

    const imageWidget = new Gtk.Image()
    imageWidget.set_from_pixbuf(wallpaperImageThumbnail)

    const themeWidget = Widget.Button({
        class_name: "normal-button",
        on_primary_click: () => {
            Log.Info(`Setting active theme to ${theme.name}`)
            Log.Info(`JSON theme object ${JSON.stringify(theme)}`)
            Utils.execAsync(`theme -A '${JSON.stringify(theme)}'`) // Set theme from json object 
        },
        child: Widget.Box({
            vertical: true,
            spacing: 8,
            children: [
                // Name
                Widget.Label({
                    hpack: "start",
                    css: `
                        font-weight: bold;
                    `,
                    label: theme.name,
                }),
                Widget.Overlay({
                    pass_through: true,
                    child: imageWidget, // wallpaper
                    overlays: [
                        // Colorscheme
                        Widget.Box({
                            css: `
                                background-color: ${colorschemeJson.special.background};
                                border-radius: 1em;
                                padding: 0.4em;
                            `,
                            hpack: "center",
                            hexpand: true,
                            vpack: "center",
                            children: [
                                colorGrid,
                            ],
                        })
                    ],
                })
            ]
        })
    })

    return themeWidget
}

export const ThemeMenu = () => Widget.Box({
    vertical: true,
    children: [
        // Light / dark toggle switch
        Widget.Box({
            css: `
                margin: 0.4em;
            `,
            children: [
                Widget.Label({
                    //label: themeState.bind().as(v => v != null ? v[0].toUpperCase() + v.slice(1) : "..."),
                    label: currentThemeJson.bind().as(v => v.mode),
                }),
                Widget.Switch({
                    class_name: "switch-off",
                    hexpand: true,
                    hpack: "end",
                    onActivate: (self) => {
                        self.toggleClassName("switch-off", !self.active)
                        self.toggleClassName("switch-on", self.active)
                        if (self.active){
                            currentThemeJson.value.mode = "dark"
                            Utils.execAsync(`theme -D`)
                        }
                        else {
                            currentThemeJson.value.mode = "light"
                            Utils.execAsync(`theme -L`)
                        }
                    },
                    hpack: "end",
                    vpack: "center",
                    active: true,
                    setup: (self) => {
                        self.toggleClassName("switch-off", !self.active)
                        self.toggleClassName("switch-on", self.active)
                        
                        if (currentThemeJson.value.mode == "dark"){
                            self.active = true
                        }
                        else{
                            self.active = false
                        }
                    }
                }),
            ],
        }),

        Widget.Label({
            hpack: "start",
            css: `
                margin-bottom: 0.4em;
            `,
            label: "Recent themes",
        }),

        // Recent themes
        Widget.Scrollable({
            class_name: "container",
            hscroll: "never",
            vexpand: true,   
            child: Widget.Box({
                vertical: true,
                spacing: 8,
                css: `
                    min-height: 1px;
                `,
                children: recentThemesJson.bind().as((v) => {
                    return GenerateRecentThemeWidgets(v)
                }),
            }),
        }),
    ]
})


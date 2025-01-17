import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import GdkPixbuf from 'gi://GdkPixbuf'
import GLib from 'gi://GLib'

import * as Global from '../Global.js'
import * as Common from '../Lib/Common.js'
import icons from '../icons.js';

////////////////////////////////////////////////////////////////////////////////////////////////////
// Globals
////////////////////////////////////////////////////////////////////////////////////////////////////
const recentThemesPath = `${GLib.get_home_dir()}/.config/leaf/theme/recent-themes.json`
const currentThemePath = `${GLib.get_home_dir()}/.config/leaf/theme/current-theme.json`

// Doing this causes those gc errors 
//const recentThemesJson = Variable(Common.ReadJSONFile(recentThemesPath))
//const currentThemeJson = Variable(Common.ReadJSONFile(currentThemePath))
//const themeState = Variable(Common.ReadJSONFile(currentThemeJson)?.mode)

const recentThemesJson = Variable(null)
const currentThemeJson = Variable(null)
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

// Probably no longer needed
/*
function GetThemeState() {
    let CurrentThemeJson = JSON.parse(Utils.readFile(currentThemeJson.value))
    return CurrentThemeJson.mode
}
*/

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
        print("ERROR: Error processing theme")
        return null
    }

    let wallpaperImage = theme.wallpaper

    // Getting the colorsceheme
    let colorschemeJsonPath = theme.colorschemePath
    let colorschemeJson = null
    print(`INFO: Reading: ${colorschemeJsonPath}`)
    try {
        const colorschemeFileData = Utils.readFile(colorschemeJsonPath)
        colorschemeJson = JSON.parse(colorschemeFileData)
    }
    catch (err){
        print(`ERROR: ${err}`)
        print("ERROR: colorschemeFileData could not be read, skipping theme...")
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

    // Add colors 1-7
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

    //const wallaperImage = Gtk.Image.new_from_file(theme.wallpaper)

    // Try to load the image
    try {
        print(`Info: Loading image ${wallpaperImage} ...`)
        GdkPixbuf.Pixbuf.new_from_file(wallpaperImage) 
    }
    catch (err){
        print("Error: " + err)
        print("Info: Image load failed, using fallback")
        wallpaperImage = icons.invalidWallpaper 
    }

    const themeWidget = Widget.Button({
        class_name: "normal-button",
        on_primary_click: () => {
            print(`INFO: Setting active theme to ${theme.name}`)
            Utils.execAsync(`theme -a ${theme.name}`)
        },
        child: Widget.Box({
            vertical: true,
            spacing: 8,
            children: [
                // Name
                Widget.Label({
                    hpack: "start",
                    label: theme.name,
                }),
                Widget.Box({
                    vertical: true,
                    children: [
                        // Wallpaper
                        Widget.Icon({
                            icon: wallpaperImage, 
                            size: 64,
                        }),
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
                    label: themeState.bind().as(v => v != null ? v[0].toUpperCase() + v.slice(1) : "..."),
                }),
                Widget.Switch({
                    class_name: "switch-off",
                    hexpand: true,
                    hpack: "end",
                    onActivate: (self) => {
                        print("INFO: Switch onActivate called")
                        print("INFO: self.active: " + self.active)
                        self.toggleClassName("switch-off", !self.active)
                        self.toggleClassName("switch-on", self.active)
                        print(self.active)
                        if (self.active){
                            themeState.value = "dark"
                            Utils.execAsync(`theme -D`)
                        }
                        else {
                            themeState.value = "light"
                            Utils.execAsync(`theme -L`)
                        }
                    },
                    hpack: "end",
                    vpack: "center",
                    active: true,
                    setup: (self) => {
                        self.toggleClassName("switch-off", !self.active)
                        self.toggleClassName("switch-on", self.active)
                        
                        if (themeState.value == "dark"){
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


import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Gtk from 'gi://Gtk'
import GdkPixbuf from 'gi://GdkPixbuf'

import * as Global from '../Global.js'
import icons from '../icons.js';


export const ThemeButton = (w, h) => Widget.Button({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
        font-size: 22px;
    `,
    on_primary_click: () => { 
        Global.ControlPanelTab.setValue("theme")
    },
    child: Widget.Icon({
        icon: "org.gnome.Settings-color-symbolic",
    })
})

function GetThemeState() {
    // WARNING: Assumes ags config dir is located at ~/.config/ags
    let CurrentThemeJsonPath = `${App.configDir}/../leaf/theme/current-theme.json`
    let CurrentThemeJson = JSON.parse(Utils.readFile(CurrentThemeJsonPath))
    //print(JSON.stringify(CurrentThemeJson.mode))
    return CurrentThemeJson.mode
}

// WARNING: Assumes ags config dir is located at ~/.config/ags
const RecentThemesPath = `${App.configDir}/../leaf/theme/recent-themes.json`

// Returns a list of the recent themes as widgets given the recent-themes.json as input
const GenerateRecentThemeWidgets = (recentThemesJson) => {
    
    //print(JSON.stringify(recentThemesJson, null, 4)) 

    let recentThemesList = []

    for (let themeKey in recentThemesJson){
        let theme = recentThemesJson[themeKey]

        // Error checking
        if (theme == null || theme.colorscheme == ""){
            print("Error processing theme")
            continue
        }

        let wallpaperImage = theme.wallpaper

        // Generating colorscheme widget
        let colorschemeJsonPath = theme.colorschemePath
        let colorschemeJson = JSON.parse(Utils.readFile(colorschemeJsonPath))
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
            print(err)
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
                            Widget.Icon({
                                icon: wallpaperImage, 
                                size: 64,
                            }),
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
                    // Colorscheme
                    // Wallpaper
                ]
            })
        })
        recentThemesList.push(themeWidget)
    } 
    return recentThemesList
}

// Stores a list of the recent themes as widgets
const recentThemesJson = JSON.parse(Utils.readFile(RecentThemesPath))
const RecentThemes = Variable(GenerateRecentThemeWidgets(recentThemesJson))

const RecentThemesMonitor = Utils.monitorFile(RecentThemesPath, (file, event) => {
    var contents = Utils.readFile(file)
    // Regenerate the themes
    RecentThemes.value = GenerateRecentThemeWidgets(JSON.parse(contents))
})

GetThemeState()

export const ThemeState = Variable(GetThemeState(), {})
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
                    label: ThemeState.bind().as(v => v[0].toUpperCase() + v.slice(1)),
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
                            ThemeState.value = "Dark"
                            Utils.execAsync(`theme -D`)
                        }
                        else {
                            ThemeState.value = "Light"
                            Utils.execAsync(`theme -L`)
                        }
                    },
                    hpack: "end",
                    vpack: "center",
                    active: true,
                    setup: (self) => {
                        self.toggleClassName("switch-off", !self.active)
                        self.toggleClassName("switch-on", self.active)
                        
                        if (ThemeState.value == "dark"){
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
                children: RecentThemes.bind(),
            }),
        }),
    ]
})


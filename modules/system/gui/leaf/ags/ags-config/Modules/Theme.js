import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Gtk from 'gi://Gtk'
import { ControlPanelTab } from '../Global.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'
//import Variable from 'resource:///com/github/Aylur/ags/variable.js';

export const ThemeButton = (w, h) => Widget.Button({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
        font-size: 22px;
    `,

    on_primary_click: () => { 
        ControlPanelTab.setValue("theme")
    },
    child: Widget.Icon({
        icon: "org.gnome.Settings-color-symbolic",
    })
})

function GetThemeState() {
    // WARNING: Assumes ags config dir is located at ~/.config/ags
    let CurrentThemeJsonPath = `${App.configDir}/../leaf/theme/current-theme.json`
    let CurrentThemeJson = JSON.parse(Utils.readFile(CurrentThemeJsonPath))
    print(JSON.stringify(CurrentThemeJson.mode))
    return CurrentThemeJson.mode
}

// WARNING: Assumes ags config dir is located at ~/.config/ags
const RecentThemesPath = `${App.configDir}/../leaf/theme/recent-themes.json`
const RecentThemes = Variable({})
const RecentThemesMonitor = Utils.monitorFile(RecentThemesPath, (file, event) => {
    print(Utils.readFile(file), event)
})


export const GenerateColorschemeWidget = (colorschemeJsonPath) => {

    let colorschemeJson = JSON.parse(Utils.readFile(colorschemeJsonPath))

    const colorGrid = new Gtk.Grid()
    // Usage:
    //     Grid.attach(columnNum, rowNum, widthNum, heighNum) 

    let colors = colorschemeJson["colors"]

    let colorNum = 0
    for (let key in colors){
        let color = colors[key]
        print("Color = " + color)
        let colorWidget = Widget.Box({
            css: `
                background-color: ${color};
                min-width: 2em;
                min-height: 2em;
                border-radius: 100%;
                margin: 0.2em;
            `,
        })
        let col = colorNum < 8 ? colorNum + 1 : colorNum + 1 - 8
        let row = colorNum < 8 ? 1 : 2
        print(`row = ${row} | col = ${col}`)
        colorGrid.attach(colorWidget, col, row, 1, 1)
        colorNum++
    }

    print("")

    return Widget.Box({
        children: [
            colorGrid,
        ],
    })
}

GetThemeState()

export const ThemeState = Variable(GetThemeState(), {})
export const ThemeMenu = () => Widget.Box({
    vertical: true,
    children: [
        Widget.FileChooserButton({
            onFileSet: ({ uri }) => {
                print(uri)
            },
        }),

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
                            execAsync(`theme -D`)
                        }
                        else {
                            ThemeState.value = "Light"
                            execAsync(`theme -L`)
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

        Widget.Box({
            vertical: true,
            children: [
                GenerateColorschemeWidget("/home/eXia/.config/wallust/pywal-colors/dark/3024.json"),
                GenerateColorschemeWidget("/home/eXia/.config/wallust/pywal-colors/dark/base16-embers.json"),
            ]
        })
    ]
})


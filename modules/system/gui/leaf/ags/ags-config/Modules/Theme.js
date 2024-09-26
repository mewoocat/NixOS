import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { ControlPanelTab } from '../Global.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'

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
            children: [
                Widget.Label({
                    label: ThemeState.bind().as(v => v[0].toUpperCase() + v.slice(1)),
                }),
                Widget.Switch({
                    class_name: "switch-off",
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

        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => {
                execAsync(['bash', '-c', 'theme -D'])
            }, 
            child: Widget.Label({
                label: "Dark theme",
            }),
        }),
        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => {
                execAsync(['bash', '-c', 'theme -L'])
            }, 
            child: Widget.Label({
                label: "Light theme",
            }),
        })
    ]
})


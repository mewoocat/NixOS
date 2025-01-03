import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Gtk from 'gi://Gtk'

// Modules
import * as Common from '../Lib/Common.js';
import * as Display from '../Modules/Display.js';
import * as Audio from '../Modules/Audio.js';
import * as Network from '../Modules/Network.js';
import * as Bluetooth from '../Modules/Bluetooth.js';
import * as Battery from '../Modules/Battery.js';
import * as SystemStats from '../Modules/SystemStats.js';
import * as Theme from '../Modules/Theme.js'
import * as Power from '../Modules/Power.js';
import * as NightLight from '../Modules/NightLight.js';
import * as ScreenCapture from '../Modules/ScreenCapture.js';
import * as Settings from '../Windows/Settings.js'
import * as User from '../Modules/User.js';
import * as Global from '../Global.js';
import * as Options from '../Options/options.js';
import icons from '../icons.js';

//////////////////////////////////////////////////////////////////
// Constants
//////////////////////////////////////////////////////////////////
const WINDOW_NAME = "ControlPanel"
const GRID_SPACING = 4
// Usage: Grid.attach(columnNum, rowNum, widthNum, heighNum)
const grid = Global.Grid()

//////////////////////////////////////////////////////////////////
// Helper functions
//////////////////////////////////////////////////////////////////

// Make widget a formated button with action on click
export function ControlPanelButton(widget, w, h, action) {
    const button = Widget.Button({
        class_name: "control-panel-button",
        on_clicked: action,
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        widget,
    })
    return button;
}

// Make widget a formated box
export function ControlPanelBox(widget, w, h) {
    const box = Widget.Box({
        class_name: "control-panel-box",
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        children: [ widget ],
    })
    return box;
}

//////////////////////////////////////////////////////////////////
// Create control panel widgets to add to the main grid 
//////////////////////////////////////////////////////////////////

// Wireless
const wirelessGrid = Global.Grid()
const wirelessWidget = ControlPanelBox(
    Widget.Box({
        hpack: "fill",
        vpack: "center",
        css: `
            margin-left: 0.6em;
            margin-right: 0.6em;
        `,
        hexpand: true,
        vertical: true,
        children: [
            Network.wifiButton2x1,
            Bluetooth.bluetoothButton2x1,
        ],
    }),
    Options.Options.system.xlarge,
    Options.Options.system.large,
)

const systemStatsWidget = ControlPanelBox(
    SystemStats.systemStatsBox2x2,
    Options.Options.system.xlarge,
    Options.Options.system.large,
)

const buttonGrid = Global.Grid()
buttonGrid.attach(NightLight.NightLightButton(Options.Options.system.small, Options.Options.system.small), 1, 1, 1, 1)
buttonGrid.attach(Power.PowerProfilesButton(Options.Options.system.small, Options.Options.system.small), 1, 2, 1, 1)
buttonGrid.attach(Theme.ThemePanelButton(Options.Options.system.small, Options.Options.system.small), 2, 1, 1, 1)
buttonGrid.attach(ScreenCapture.ScreenRecordButton(Options.Options.system.small, Options.Options.system.small), 2, 2, 1, 1)

const sliders = Widget.Box({
    class_name: "control-panel-box",
    css: `
        padding: 0.6rem;
    `,
    vertical: true,
    spacing: 8,
    children: [
        Display.brightness(),
        Audio.VolumeSlider(),
        Audio.MicrophoneSlider(),
    ]
})

const bottom = Widget.CenterBox({
    hexpand: true,
    css: `
        min-height: ${Options.Options.system.xsmall}rem;
    `,
    class_name: `control-panel-box`,
    startWidget: User.UserInfo,
    centerWidget: Widget.Label(''),
    endWidget: Widget.Box({
        hpack: "end",
        children: [
            Settings.SettingsToggle,
            Widget.Separator({class_name: "vertical-separator"}),
            Power.togglePowerMenu,
        ],
    }),
})

// Row 1
const row1 = Global.Grid()
row1.attach(wirelessWidget, 1, 1, 1, 1)
row1.attach(buttonGrid, 2, 1, 1, 1)

// Row 2
const row2 = Global.Grid()
row2.attach(sliders, 1,2,2,1)

// Row 3
const row3 = Global.Grid()
if (Battery.isAvailable()){
    row3.attach(Battery.BatteryWidget(Options.Options.system.large, Options.Options.system.large), 1, 3, 1, 1)
}
else{
    row3.attach(SystemStats.GPUWidget(Options.Options.system.large, Options.Options.system.large), 1, 3, 1, 1)
}
row3.attach(systemStatsWidget, 2, 3, 1, 1)

// Row 4
const row4 = Global.Grid()
row4.attach(bottom, 1,4,2,1)





//////////////////////////////////////////////////////////////////
// Setup submenus
//////////////////////////////////////////////////////////////////
const SetTab = (dst) => {
    Global.ControlPanelTab.setValue(dst)
}

const BackButton = (dst = "main", customCallback = null) => {
    if (customCallback == null){
        return Common.CircleButton(icons.back, SetTab, [dst])
    }
    return Common.CircleButton(icons.back, customCallback, [])
}




const mainContainer = () => Widget.Box({
    vertical: true,
    children: [
        row1,
        row2,
        row3,
        row4,
    ],
});

const networkMain = () => Widget.Box({
    vertical: true,
    spacing: 8,
    children: [
        Network.CurrentNetwork(),
        Widget.Box({
            children:[
                Widget.Label({
                    label: "Available networks",
                    vpack: "center",
                    hpack: "start",
                }),
                Widget.Box({
                    hexpand: true,
                    hpack: "end",
                    vpack: "center",
                    children: [
                        Network.RefreshWifi(),
                    ]
                }),
            ]
        }),
        Network.WifiList(),
    ]
})

const networkContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    spacing: 8,
    children: [
        Widget.Box({
            spacing: 8,
            children: [
                BackButton("n/a", Network.NetworkBack), 
                Network.WifiStatus(),
            ]
        }),

        Widget.Stack({
            // Tabs
            children: {
                'main': networkMain(),
                'ap': Network.AccessPoint(),
            },
            transition: "slide_left_right",

            // Select which tab to show
            setup: self => self.hook(Global.ControlPanelNetworkTab, () => {
                self.shown = Global.ControlPanelNetworkTab.value;
            })
        })

    ],
})

const volumeContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    spacing: 4,
    children: [
        // Top bar
        Widget.Box({
            spacing: 8,
            children: [
                BackButton(),
                Widget.Label("Volume"),
            ]
        }),
        Audio.VolumeMenu(), 
    ],
})

const microphoneContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        // Top bar
        Widget.Box({
            spacing: 8,
            children: [
                BackButton(),
                Widget.Label("Microphone"),
            ]
        }),
        Audio.MicrophoneMenu(), 
    ],
})

const BTDevice = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        Bluetooth.BluetoothDevice(),
    ],
})

const bluetoothContainer = () => Widget.Box({
    spacing: 8,
    vertical: true,
    vexpand: false,
    children: [

        Widget.Box({
            spacing: 8,
            children: [
                BackButton("n/a", Bluetooth.BluetoothBack), 
                Bluetooth.BluetoothStatus(),
            ]
        }),

        Widget.Stack({
            // Tabs
            children: {
                'main': Bluetooth.BluetoothMenu(),
                'device': BTDevice(),
            },
            transition: "slide_left_right",

            // Select which tab to show
            setup: self => self.hook(Global.ControlPanelBluetoothTab, () => {
                self.shown = Global.ControlPanelBluetoothTab.value;
            })
        })
    ],
})


const ThemeContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        Widget.Box({
            spacing: 8,
            children: [
                BackButton(),
                Widget.Label("Appearance"),
            ]
        }),
        Theme.ThemeMenu(),
    ],
})

// Container
const stack = Widget.Stack({
    // Tabs
    children: {
        'main': mainContainer(),
        'network': networkContainer(),
        'volume': volumeContainer(),
        'microphone': microphoneContainer(),
        'bluetooth': bluetoothContainer(),
        'theme': ThemeContainer(),
    },
    transition: "slide_left_right",

    // Select which tab to show
    setup: self => self.hook(Global.ControlPanelTab, () => {
        self.shown = Global.ControlPanelTab.value;
    })
})


const content = Widget.Revealer({
    revealChild: false,
    transitionDuration: 150,
    transition: "slide_left",
    setup: self => {
        self.hook(App, (self, windowName, visible) => {
            if (windowName === "ControlPanel"){
                self.revealChild = visible
                Global.ControlPanelTab.setValue("main")
            }
        }, 'window-toggled')
    },
    child: Widget.Box({
        class_name: "toggle-window",
        children: [
            stack,
        ],
    }),
})

export const ControlPanelToggleButton = (monitor) => Widget.Button({
    class_name: 'launcher normal-button',
    on_primary_click: () => Utils.execAsync(`ags -t ControlPanel`),
    child: Widget.Label({
        label: ""
    }) 
});

export const ControlPanel = () => Widget.Window({
    name: WINDOW_NAME,
    css: `background-color: unset;`,
    visible: false,
    layer: "overlay",
    keymode: "exclusive",
    //anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    anchor: ["top", "left", "right"], // Debug mode
    exclusivity: 'normal',
    child: Common.CloseOnClickAway("ControlPanel", content, "top-right"),
    setup: self => {
        //self.show_all()
        //self.visible = false
        self.keybind("Escape", () => App.closeWindow(WINDOW_NAME))
    }
});

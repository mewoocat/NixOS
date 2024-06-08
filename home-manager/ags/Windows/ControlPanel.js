
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

// Modules
import { brightness } from '../Modules/Display.js';
import { VolumeSlider, VolumeMenu } from '../Modules/Volume.js';
import { MicrophoneSlider } from '../Modules/Microphone.js';
import { RefreshWifi, WifiPanelButton, WifiSSID, WifiIcon, WifiList, APInfo} from '../Modules/Network.js';
import { BluetoothStatus, BluetoothPanelButton, BluetoothConnectedDevices, BluetoothDevices } from '../Modules/Bluetooth.js';
import { BatteryWidget } from '../Modules/Battery.js';
import { SystemStatsWidgetLarge, GPUWidget } from '../Modules/SystemStats.js';
import { ThemeButton, ThemeMenu } from '../Modules/Theme.js'
import { DisplayButton } from '../Modules/Display.js';
import { PowerProfilesButton } from '../Modules/Power.js';
import { NightLightButton } from '../Modules/NightLight.js';
import { CloseOnClickAway } from '../Common.js';
import { ScreenRecordButton } from '../Modules/ScreenCapture.js';

// Variables
import { ControlPanelTab, APInfoVisible } from '../variables.js';

// Options
import options from '../options.js';


import Gtk from 'gi://Gtk'
const grid = new Gtk.Grid()
//grid.set_column_spacing(8)
//grid.set_row_spacing(8)

// Row 1
const grid1A = new Gtk.Grid()
grid1A.attach(WifiPanelButton(options.large, options.small), 1, 1, 2, 1)
grid1A.attach(BluetoothPanelButton(options.large, options.small), 1, 2, 2, 1)
grid.attach(grid1A, 1, 1, 1, 1)
grid.attach(SystemStatsWidgetLarge(options.large, options.large), 2, 1, 1, 1)

// Row 2
const sliders = Widget.Box({
    class_name: "control-panel-audio-box",
    vertical: true,
    spacing: 8,
    children: [
        brightness(),
        VolumeSlider(),
        MicrophoneSlider(),
    ]
})
grid.attach(sliders, 1,2,2,1)

// Row 3

if (Battery.available){
    grid.attach(BatteryWidget(options.large, options.large), 1, 3, 1, 1)
}
else{
    grid.attach(GPUWidget(options.large, options.large), 1, 3, 1, 1)
}

const grid3B = new Gtk.Grid()
grid3B.attach(NightLightButton(options.small, options.small), 1, 1, 1, 1)
grid3B.attach(PowerProfilesButton(options.small, options.small), 1, 2, 1, 1)
grid3B.attach(ThemeButton(options.small, options.small), 2, 1, 1, 1)
//grid3B.attach(DisplayButton(options.small, options.small), 2, 2, 1, 1)
grid3B.attach(ScreenRecordButton(options.small, options.small), 2, 2, 1, 1)
grid.attach(grid3B, 2, 3, 1, 1)

// Row 4
const BackButton = (dst = "main") => Widget.Button({
    class_name: `normal-button`,
    //hexpand: true,
    onClicked: () => {
        ControlPanelTab.setValue(dst)
        APInfoVisible.value = false
    },
    child: Widget.Label({
        label: "Back",
    })
})

// Make widget a formated button with action on click
function ControlPanelButton(widget, edges, w, h, action) {
    const button = Widget.Button({
        class_name: `control-panel-button`,
        on_clicked: action,
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        child:
            Widget.Box({
                hexpand: true,
                class_name: `${edges}`,
                children: [
                    widget
                ]
            })
    })
    return button;
}

// Make widget a formated box
function ControlPanelBox(widget, w, h) {
    const box = Widget.Box({
        class_name: `control-panel-box`,
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        child:
            widget
    })
    return box;
}


const mainContainer = () => Widget.Box({
    vertical: true,
    children: [
        grid,
    ],
});


const networkContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        Widget.CenterBox({
            hexpand: true,
            startWidget: RefreshWifi(),
            endWidget: BackButton(),
        }),
        Widget.Box({
            vexpand: true,
            vertical: true,
            setup: self => {
                self.hook(APInfoVisible, self => {
                    if (APInfoVisible.value == true){
                        self.children = [ APInfo() ] 
                    }
                    else{
                        self.children = [ WifiList() ]
                    }
                })
            },
        })
    ],
})

const networkAPContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        BackButton("network"),
        APInfo(),
    ],
})

const audioContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        BackButton(),
        VolumeMenu(), 
    ],
})

const bluetoothContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        Widget.CenterBox({
            startWidget: BluetoothStatus(),
            endWidget: BackButton(),
        }),
        BluetoothDevices(),
        BluetoothConnectedDevices(),
    ],
})

const ThemeContainer = () => Widget.Box({
    vertical: true,
    vexpand: false,
    children: [
        BackButton(),
        ThemeMenu(),
    ],
})

// Container
const stack = Widget.Stack({
    // Tabs
    children: {
        'main': mainContainer(),
        'network': networkContainer(),
        'ap': networkAPContainer(),
        'audio': audioContainer(),
        'bluetooth': bluetoothContainer(),
        'theme': ThemeContainer(),
    },
    transition: "slide_left_right",

    // Select which tab to show
    setup: self => self.hook(ControlPanelTab, () => {
        self.shown = ControlPanelTab.value;
    })
})



const content = Widget.Box({
    class_name: "toggle-window",
    children: [
        Widget.Revealer({
            revealChild: false,
            transitionDuration: 150,
            transition: "slide_down",
            setup: self => {
                self.hook(App, (self, windowName, visible) => {
                    if (windowName === "ControlPanel"){
                        self.revealChild = visible
                        ControlPanelTab.setValue("main")
                    }
                }, 'window-toggled')
            },
            child: Widget.Box({
                children: [
                    stack,
                ],
            }),
        })
    ],
})

export const ControlPanelToggleButton = (monitor) => Widget.Button({
    class_name: 'launcher normal-button',
    on_primary_click: () => {
        execAsync(`ags -t ControlPanel`)
    },
    child: Widget.Label({
        label: ""
    }) 
});

export const ControlPanel = Widget.Window({
    name: `ControlPanel`,
    visible: false,
    keymode: "exclusive",
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top", "bottom", "right"], // Debug mode
    exclusivity: 'normal',
    child: CloseOnClickAway("ControlPanel", content, "top-right")
});


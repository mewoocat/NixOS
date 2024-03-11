
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

// Modules
import { brightness } from '../Modules/brightness.js';
import { VolumeSlider } from '../Modules/volume.js';
import { MicrophoneSlider } from '../Modules/microphone.js';
import { WifiButton, WifiSSID, WifiIcon } from '../Modules/network.js';
import { BluetoothIcon, ToggleBluetooth, BluetoothButton } from '../Modules/bluetooth.js';
import { BatteryWidget } from '../Modules/battery.js';
import { SystemStatsWidgetLarge} from '../Modules/system_stats.js';
import { ThemeIcon } from '../Modules/theme.js'
import { PowerProfilesButton } from '../Modules/power.js';
import { Weather } from '../Modules/Weather.js';
import { NightLightButton, NightlightIcon, ToggleNightlight } from '../Modules/nightlight.js';
import options from '../options.js';

// Variables
import { ControlPanelTab } from '../variables.js';

import Gtk from 'gi://Gtk'
const grid = new Gtk.Grid()
//grid.set_column_spacing(8)
//grid.set_row_spacing(8)

// Row 1
const grid1A = new Gtk.Grid()
grid1A.attach(WifiButton(options.large, options.small), 1, 1, 2, 1)
grid1A.attach(BluetoothButton(options.large, options.small), 1, 2, 2, 1)
grid.attach(grid1A, 1, 1, 1, 1)
grid.attach(BatteryWidget(0,0), 2, 1, 1, 1)

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
grid.attach(Weather(options.large, options.large), 1, 3, 1, 1)
const grid3B = new Gtk.Grid()
grid3B.attach(NightLightButton(options.small, options.small), 1, 1, 1, 1)
grid3B.attach(PowerProfilesButton(options.small, options.small), 1, 2, 1, 1)
grid3B.attach(NightLightButton(options.small, options.small), 2, 1, 1, 1)
grid3B.attach(NightLightButton(options.small, options.small), 2, 2, 1, 1)
grid.attach(grid3B, 2, 3, 1, 1)

// Row 4
grid.attach(SystemStatsWidgetLarge(options.large, options.large), 1, 4, 2, 1)



// Make widget a formated button with action on click
function ControlPanelButton(widget, edges, w, h, action) {
    const button = Widget.Button({
        class_name: `control-panel-button`,
        on_clicked: action,
        //hpack: "center",
        //vpack: "center",
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
        //hpack: "center",
        //vpack: "center",
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
    class_name: "control-panel-container",
    css: `
        margin: 1rem;
        padding: 0.5rem;
    `,
    spacing: 8,
    vertical: true,
    children: [
        grid,
    ],
});


const networkContainer = () => Widget.Box({
    class_name: "control-panel-container",
    css: `
        margin: 1rem;
        padding: 0.5rem;
    `,
    spacing: 8,
    vertical: true,
    children: [
        //Rows
        Widget.Box({
            children: [
                WifiIcon(),
                WifiSSID()
            ]
        }),

        Widget.Scrollable({
            css: `
                min-height: 400px;
            `,
            child:
                Widget.Label({label: "Found Networks"})  
        })
    ],
});


import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
// Container
const stack = Widget.Stack({
    // Tabs
    children: {
        'child1': mainContainer(),
        'child2': networkContainer(),
    },
    transition: "over_left",

    // Select which tab to show
    setup: self => self.hook(ControlPanelTab, () => {
        self.shown = ControlPanelTab.value;
    })
})



const content = Widget.Box({
    css: 'padding: 1px;',
    child: Widget.Revealer({
        revealChild: false,
        transitionDuration: 150,
        transition: "slide_down",
        setup: self => {
            self.hook(App, (self, windowName, visible) => {
                if (windowName === "ControlPanel"){
                    self.revealChild = visible
                    ControlPanelTab.setValue("child1")
                }
            }, 'window-toggled')
        },
        child: stack,
    })
})

export const ControlPanelToggleButton = (monitor) => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => {
        execAsync(`ags -t ControlPanel`)
    },
    child:
        Widget.Label({
            label: ""
        }) 
});

export const ControlPanel = Widget.Window({
    //name: `ControlPanel-${monitor}`, // name has to be unique
    name: `ControlPanel`,
    class_name: 'control-panel',
    visible: false,
    //keymode: "exclusive",
    anchor: ['top', 'right'],
    exclusivity: 'normal',
    child: content,
});


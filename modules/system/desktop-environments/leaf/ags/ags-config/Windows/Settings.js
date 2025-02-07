// This can be used to launch window from this file
//#!/usr/bin/env -S ags -b "settings" -c

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Gtk from 'gi://Gtk'

import * as Network from '../Modules/Network.js';
import * as Audio from '../Modules/Audio.js';
import * as Bluetooth from '../Modules/Bluetooth.js';
import * as Settings from '../Modules/Settings.js'
import * as Log from '../Lib/Log.js'
import icons from '../icons.js';


const Window = Widget.subclass(Gtk.Window, "Window");
const SettingsTab = Variable("General", {})


// Testing
const colorbutton = Widget.ColorButton({
    onColorSet: ({ rgba: { red, green, blue, alpha } }) => {
        print(`rgba(${red * 255}, ${green * 255}, ${blue * 255}, ${alpha})`)
    },
})
const fontbutton = Widget.FontButton({
    onFontSet: ({ font }) => {
        print(font)
    },
})
const switchButton = Widget.Switch({
    onActivate: ({ active }) => print(active),
})
const togglebutton = Widget.ToggleButton({
    onToggled: ({ active }) => print(active),
})
const spinner = Widget.Spinner()

const tabs = [
    "General",
    "Display",
    //"Appearance",
    //"Network",
    //"Bluetooth",
    //"Devices",
    //"Sound",
    //"About",
]

const Tab = (t) => {

    return Widget.Button({
        class_name: "settings-tab-button",
        css: `
            margin-right: 1rem;
        `,
        on_primary_click: (self) =>{
            SettingsTab.value = t
        },
        setup: (self) => {
            // Highlight current tab on startup
            if (t === SettingsTab.value){
                self.toggleClassName("settings-tab-active", true)
            }
            self.hook(SettingsTab, (self) => {
                self.toggleClassName("settings-tab-active", t === SettingsTab.value)
            }, "changed")
        },
        child: Widget.Label({
            label: t,
        }),

    })
}

const Tabs = () => Widget.Box({
    vertical: true,
    children: tabs.map(Tab)
})

function Container(name, contents){

    return Widget.Box({
        class_name: "padder",
        vertical: true,
        hexpand: true,
        children: [
            Widget.CenterBox({
                startWidget: Widget.Label({
                    label: name,
                    class_name: "header",
                    hpack: "start",
                }),
                endWidget: Widget.Box({
                    hpack: "end",
                    children: [
                        Settings.ChangedOptionsIndicator(),
                        Settings.ApplyButton(),
                    ],
                }),
            }),
            /*
            Widget.Separator({
                class_name: "horizontal-separator",
            }),
            */
            contents,
        ],
        setup: (self) => {
            // Trying to react to resizing
            // Doesn't work :(
            self.connect("size-allocate", (widget, allocation) =>{
                Log.Info(`Window size: ${allocation.width}x${allocation.height}`)
            })
        }
    })
}


function SectionHeader(name){ 

    return Widget.Box({
        css: `
            margin-top: 0.6rem;
            margin-bottom: 0.6rem;
        `,
        vertical: true,
        children: [
            Widget.Label({
                class_name: "sub-header",
                hpack: "start",
                label: name,
            }),
            /*
            Widget.Separator({
                class_name: "horizontal-separator",
            }),
            */
        ],
    })
}
const generalContents = () => Widget.Scrollable({
    hscroll: 'never',
    vscroll: 'always',
    vexpand: true,
    child: Settings.generalSettings,
})

const displayContents = () => Widget.Scrollable({
    hscroll: 'never',
    vscroll: 'always',
    vexpand: true,
    child: Settings.displaySettings,
})

const testContents = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label({
            label: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
            wrap: true,
        }),
        Widget.Button({
            hpack: "fill",
            class_name: "shadow-button",
            child: Widget.Label("Button"),
        }),
    ]
})

const networkContents = () => Widget.Box({
    children: [
        Network.WifiList(),
    ]
})

const bluetoothContents = () => Widget.Box({
    vertical: true,
    children: [
        Bluetooth.BluetoothStatus(),
        Bluetooth.BluetoothConnectedDevices(),
        Bluetooth.BluetoothDevices(),
        Bluetooth.BluetoothDevice(),
    ],
})

const soundContents = () => Widget.Box({
    vertical: true,
    children: [
        SectionHeader("Volume"),
        Audio.VolumeMenu(), 
        SectionHeader("Microphone"),
        Audio.MicrophoneMenu(),
    ]
})


const TabContainer = () => Widget.Stack({      
    // Tabs
    children: {
        'General': Container("General", generalContents()),
        'Display': Container("Display", displayContents()),
        //'Appearance': Container("Appearance", testContents()),
        //'Network': Container("Network", networkContents()),
        //'Bluetooth': Container("Bluetooth", bluetoothContents()),
        //'Devices': Container("Devices", testContents()),
        //'Sound': Container("Sound", soundContents()),
        //'About' : Container("About", testContents()),
    },
    transition: "slide_up_down",

    // Select which tab to show
    setup: self => self.hook(SettingsTab, () => {
        self.shown = SettingsTab.value;
    })
})

const LeftPanel = () => Widget.Box({
    vertical: true,
    spacing: 8,
    class_name: "tab-container",
    children: [
        Widget.Box({
            spacing: 8,
            children: [
                Widget.Icon({
                    size: 20,
                    icon: icons.settings,
                }),
                Widget.Label({
                    class_name: "large-text",
                    label: "Settings",
                })
            ]
        }),
        Tabs(),
    ]
})

export const SettingsToggle = Widget.Button({
    class_name: "normal-button",
    on_primary_click: () => {
        App.closeWindow("Settings")
        App.closeWindow("ControlPanel")
        App.openWindow("Settings")   
    },
    child: Widget.Icon({
        size: 20,
        icon: icons.settings,
    })
})

// Settings window (Normal window)
export const SettingsWin = () => Window({
    name: "Settings",
    child: Widget.Box({
        class_name: "normal-window",
        children: [
            LeftPanel(),
            TabContainer(),
        ],
    }),
    setup: (self) => {
        //self.show_all(); // This may or may not be needed
        self.visible = false;
        self.on("delete-event", () => {
            App.closeWindow("Settings")
            return true
        })
    },
})


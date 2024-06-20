// This can be used to launch window from this file
//#!/usr/bin/env -S ags -b "settings" -c

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { RefreshWifi, WifiSSID, WifiIcon, WifiList, APInfo } from '../Modules/Network.js';
import { PowerProfilesButton } from '../Modules/Power.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

import { brightness } from '../Modules/Display.js';
import { VolumeSlider, VolumeMenu } from '../Modules/Volume.js';
import { MicrophoneMenu, MicrophoneSlider } from '../Modules/Microphone.js';
import { Refresh, BluetoothStatus, BluetoothPanelButton, BluetoothConnectedDevices, BluetoothDevices, BluetoothDevice } from '../Modules/Bluetooth.js';
import { BatteryWidget } from '../Modules/Battery.js';
import { ThemeButton, ThemeMenu } from '../Modules/Theme.js'
import icons from '../icons.js';

const { Gtk } = imports.gi;
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';

const Window = Widget.subclass(Gtk.Window, "Window");

const SettingsTab = Variable("general", {})

const gapsInSpinButton = Widget.SpinButton({
    hpack: "start",
    value: 20,
    range: [0, 100],
    increments: [1, 5],
    onValueChanged: ({ value }) => {
        print(value)
    },
})

const gapsOutSpinButton = Widget.SpinButton({
    hpack: "start",
    range: [0, 100],
    increments: [1, 5],
    onValueChanged: ({ value }) => {
        print(value)
        gapsWorkspacesSlider.value = 900 // This works for setting initial value
    },
})
const gapsWorkspacesSlider = Widget.Slider({
    class_name: "sliders",
    onChange: ({ value }) => print(value),
    //vertical: true,
    hexpand: true,
    //value: 40,
    min: 800,
    max: 1000,
    value: 900,
    setup: (self) => {
        self.value = 900
    }
})

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


function CreateOptionWidget(type){
    switch(type){
        case "slider":
            break
        case "switch":
            break
        case "spin":
            break
    }
}






// TODO
// Create json to store json key value pairs for settings
// iterate over json to get keys which would have the same name in the options object
// load values for each option


// Read in user settings
const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))

// Option object constructor
function Option(identifer, name, widget, before, value, after) {
    this.identifer = identifer  // Unique reference to option 
    this.name = name            // Human readable name
    this.widget = widget        // Reference to widget
    this.before = before        // Option string before value
    this.value = value          // Option value
    this.after = after          // Option string after value
}

let Options = {
    gapsIn: new Option("gaps_in", "Gaps in", gapsInSpinButton, "general:gaps_in = ", data.options.gaps_in, ""),
    gapsOut: new Option("gaps_out", "Gaps out", gapsOutSpinButton, "general:gaps_out = ", data.options.gaps_out, ""),
    gapsWorkspaces: new Option("gaps_workspaces", "Gaps workspaces", gapsWorkspacesSlider, "general:gaps_workspaces = ", data.options.gaps_workspaces, "")
}

function LoadOptionValues(){ 
    for (let key in Options){
        let opt = Options[key]

        //widget = CreateOptionWidget(opt.widget)

        // Set widget with value from json
        // = data.options[opt.identifer]

        print("value: " + opt.value)
        
    }
}

function ApplySettings(){

    // Contents to write to file
    let contents = " \n"

    // Generate option literals
    for (let o in Options){
        let opt = Options[o]

        // Get current value from associated widget
        opt.value = opt.widget.value
        
        contents = contents.concat(opt.before + opt.value + opt.after + "\n")
    }
    print("contents = " + contents)

    // Write out new settings file
    Utils.writeFile(contents, `${App.configDir}/../../.cache/hypr/userSettings.conf`)
        .then(file => print('Settings file updated'))
        .catch(err => print(err))

    // Reload hyprland config
    Hyprland.messageAsync(`reload`)
}

const ApplyButton = () => Widget.Button({
    class_name: "normal-button",
    on_primary_click: () => ApplySettings(),
    child: Widget.Label("Apply"),
})

const tabs = [
    "General",
    "Display",
    "Appearance",
    "Network",
    "Bluetooth",
    "Devices",
    "Sound",
    "About",
]

const Tab = (t) => Widget.Button({
    class_name: "normal-button",
    on_primary_click: () =>{
        print(t)
        SettingsTab.value = t
    },
    child: Widget.Label({
        label: t,
    }),

})

const Tabs = () => Widget.Box({
    vertical: true,
    children: tabs.map(Tab)
})


function Container(name, contents){
    return Widget.Box({
        vertical: true,
        hexpand: true,
        children: [
            Widget.Label({
                label: name,
                class_name: "header",
                hpack: "start",
            }),
            Widget.Separator({
                class_name: "horizontal-separator",
            }),
            contents,
        ],
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
            Widget.Separator({
                class_name: "horizontal-separator",
            }),
        ],
    })
}

const generalContents = Widget.Box({
    vertical: true,
    children: [
        SectionHeader("Power Profile"),
        PowerProfilesButton(),
        gapsInSpinButton,
        gapsOutSpinButton,
        gapsWorkspacesSlider,
        colorbutton,
        fontbutton,
        switchButton,
        spinner,
        ApplyButton(),
    ],
})

const testContents = () => Widget.Label({
    label: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
    wrap: true,
})

const networkContents = Widget.Box({
    children: [
        WifiList(),
    ]
})



const bluetoothContents = Widget.Box({
    vertical: true,
    children: [
        BluetoothStatus(),
        BluetoothConnectedDevices(),
        BluetoothDevices(),
        BluetoothDevice(),
    ],
})

const soundContents = Widget.Box({
    vertical: true,
    children: [
        SectionHeader("Volume"),
        VolumeMenu(), 
        SectionHeader("Microphone"),
        MicrophoneMenu(),
    ]
})


const TabContainer = () => Widget.Stack({      
    // Tabs
    children: {
        'General': Container("General", generalContents),
        'Display': Container("Display", generalContents),
        'Appearance': Container("Appearance", testContents()),
        'Network': Container("Network", networkContents),
        'Bluetooth': Container("Bluetooth", bluetoothContents),
        'Devices': Container("Devices", testContents()),
        'Sound': Container("Sound", soundContents),
        'About' : Container("About", testContents()),
    },
    transition: "slide_up_down",

    // Select which tab to show
    setup: self => self.hook(SettingsTab, () => {
        self.shown = SettingsTab.value;
    })
})

export const SettingsToggle = Widget.Button({
    class_name: "normal-button",
    on_primary_click: () => {
        LoadOptionValues()
        App.closeWindow("Settings")
        App.closeWindow("ControlPanel")
        App.openWindow("Settings")   
    },
    child: Widget.Icon({
        size: 20,
        icon: icons.settings,
    })
})

export const Settings = () => Window({
    name: "Settings",
    child: Widget.Box({
        class_name: "normal-window",
        children: [
            Tabs(),
            Widget.Separator({
                class_name: "vertical-separator",
            }),
            TabContainer(),
        ],
    }),
    setup: (self) => {
        self.show_all();
        self.visible = false;
        self.on("delete-event", () => {
            App.closeWindow("Settings")
            return true
        })
    },
});


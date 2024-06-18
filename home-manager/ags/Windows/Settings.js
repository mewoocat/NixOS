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

const { Gtk } = imports.gi;
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';

const Window = Widget.subclass(Gtk.Window, "Window");

const SettingsTab = Variable("general", {})

/*
class Option {
  // Constructor
  constructor(name, value) {
    // Constructor body
  }
  // Instance field
  myField = "foo";
  // Instance method
  myMethod() {
    // myMethod body
  }
  // Static field
  static myStaticField = "bar";
  // Static method
  static myStaticMethod() {
    // myStaticMethod body
  }
  // Static block
  static {
    // Static initialization code
  }
  // Fields, methods, static fields, and static methods all have
  // "private" forms
  #myPrivateField = "bar";
}
*/

function Option(name, before, value, after) {
    this.name = name
    this.before = before
    this.value = value
    this.after = after
}

let Options = {
    gapsIn: new Option("Gaps in", "general:gaps_in = ", 10, ""),
    gapsOut: new Option("Gaps out", "general:gaps_out = ", 40, ""),
}

function ApplySettings(){

    // Contents to write to file
    let contents = " \n"

    // Generate option literals
    for (let o in Options){
        let opt = Options[o]
        
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


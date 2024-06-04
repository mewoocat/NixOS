
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

import { ControlPanelTab } from '../variables.js';

var devices = []

export const BluetoothIcon = () => Widget.Icon().hook(Bluetooth, self  => {
    self.toggleClassName("dim", !Bluetooth.enabled)
    self.size = 16
    if(Bluetooth.enabled){
        self.icon = "bluetooth-active-symbolic" //"󰂯"
    }
    else{
        self.icon = "bluetooth-disabled-symbolic" //"󰂲"
    }
})

export function ToggleBluetooth(){
    if(Bluetooth.enabled){
        Bluetooth.enabled = false
    }
    else{
        Bluetooth.enabled = true
    }
}

export const BluetoothButton = (w, h) => Widget.Box({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    children: [
        Widget.Button({
            hexpand: true,
            class_name: "control-panel-sub-button round-left",
            onPrimaryClick: () => {
                ToggleBluetooth()
            }, 
            child: BluetoothIcon(),
        }),
        Widget.Button({
            hexpand: true,
            class_name: "control-panel-sub-button round-right",
            onPrimaryClick: () => {
                ControlPanelTab.setValue("bluetooth")
            }, 
            child: Widget.Icon({
                icon: "view-more-symbolic",
                size: 24
            }),
        }),
    ],
})



const device = (d) => Widget.Button({ 
    class_name: "normal-button",
    onPrimaryClick: () => {
        BluetoothInfoVisible.value = true
        CurrentDevice.value = d
    }, 
    child: Widget.CenterBox({
        startWidget: Widget.Label({
            hpack: "start",
            label: d.name
        }),
        endWidget: Widget.Box({
            hpack: "end",
            children: [
            ],
        }),
    })
})

export const BluetoothMenu = () => Widget.Scrollable({
    css: `
        min-height: 100px;
    `,
    vexpand: true,
    child: Widget.Box({
        vertical: true,
        children: [],
    }).poll(10000, self => {
        try{ 
            devices = Bluetooth.devices.map(device)
        }
        catch{ 
            devices = []
        }
        self.children = devices
    })
})























import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

import { ControlPanelTab, CurrentDevice } from '../variables.js';

var devices = []

export const BluetoothIcon = () => Widget.Icon().hook(Bluetooth, self  => {
    self.toggleClassName("dim", !Bluetooth.enabled)
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

export const BluetoothButton = () => Widget.Button({
    class_name: "normal-button",
    onPrimaryClick: () => {
        ToggleBluetooth()
    }, 
    child: BluetoothIcon(),
})

export const BluetoothPanelButton = (w, h) => Widget.Box({
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


function device(d){
    if (d.name == null){
        return null
    }
    return Widget.Button({ 
        class_name: "normal-button",
        onPrimaryClick: () => {
            CurrentDevice.value = d

            ControlPanelTab.setValue("bluetoothDevice")
        }, 
        child: Widget.CenterBox({
            startWidget: Widget.Label({
                hpack: "start",
                label: d.name
            }),
            endWidget: Widget.Box({
                hpack: "end",
                children: [
                    Widget.Icon({
                        icon: d.iconName + '-symbolic',
                    }),
                ],
            }),
        })
    })
}

export const BluetoothDevices = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label({
            hpack: "start",
            label: "Devices available",
        }),
        Widget.Scrollable({
            css: `
                min-height: 100px;
            `,
            vexpand: true,
            child: Widget.Box({
                vertical: true,
            }).hook(Bluetooth, self => {
                self.children = Bluetooth.devices.map(device)
            })
        })

    ]
})
    


export const BluetoothConnectedDevices = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label({
            hpack: "start",
            label: "Connected devices",
        }),
        Widget.Scrollable({
            css: `
                min-height: 100px;
            `,
            vexpand: true,
            child: Widget.Box({
                vertical: true,
            }).hook(Bluetooth, self => {
                self.children = Bluetooth.connectedDevices.map(device)
            })
        })

    ]
})
    

export const BluetoothStatus = () => Widget.Box({
    children: [
        BluetoothButton(),
        Widget.Switch({
            vpack: "center",
            active: Bluetooth.bind("enabled"), // Causes switch to flicker
            //onActivate: ({ active }) => Bluetooth.enabled = active,
            setup: (self) => {
                self.on("notify::active", () => {
                    Bluetooth.enabled = self.active
                })
            },
        }),
        /*
        Widget.Label({
            label: Bluetooth.bind("connectedDevices").as(d => {
                if (d.length > 0){
                    return d.length + " Connected"
                }
                else {
                    return "Disconnected"
                }
            })
            //label: "Status",
        }),
        */
    ]
})


export const BluetoothDevice = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Switch(),
        Widget.Label({
            hpack: "start",
            label: CurrentDevice.bind().as(d => d.name),
        }),
        Widget.Separator({class_name: "horizontal-separator"}),
        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => { 
                let device = Bluetooth.getDevice(CurrentDevice.value.address)
                device.setConnection(true)
                //CurrentDevice.value.setConnection(true)
            },
            child: Widget.Label({
                label: "Connect"
            })
        }),
    ]
})
















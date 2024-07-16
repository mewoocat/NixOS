
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { ControlPanelTab } from '../Global.js';
import icons from '../icons.js';
import GObject from 'gi://GObject'

// Holds current bluetooth device selected
export const CurrentDevice = Variable({}, {})

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
    //class_name: "control-panel-button",
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

const bluetoothStatus = Widget.Label({
    class_name: "sub-text",
    hpack: "start",
    label: "N/A",
    setup: (self) => {
        self.hook(Bluetooth, (self) => {
            let content = ""
            const connectedDevices = Bluetooth.connectedDevices
            if (!Bluetooth.enabled) {
                content = "Disabled"
            }
            else if (connectedDevices.length > 0) {
                content = connectedDevices.length + " Connected"
            }
            else {
                content = "Disconnected"
            }    
            self.label = content
        }, "changed")
    },
})

export const bluetoothButton2x1 = Widget.Box({
    children: [

        Widget.Button({         
            vpack: "center",
            class_name: "circle-button",
            onClicked: () => ToggleBluetooth(),
            child: BluetoothIcon(),
            setup: (self) => {
                self.hook(Bluetooth, (self) => {
                    self.toggleClassName("circle-button-active", Bluetooth.enabled)
                }, "changed")
            },
        }),
        Widget.Button({
            class_name: "normal-button",
            onClicked: () => ControlPanelTab.setValue("bluetooth"),
            child: Widget.Box({
                vertical: true,
                children: [
                    Widget.Label({
                        label: "Bluetooth",
                        hpack: "start",
                    }),
                    bluetoothStatus,
                ],
            })
        })
    ],
})


function device(d){
    if (d.name == null){
        return null
    }
    return Widget.Button({ 
        class_name: "normal-button bg-",
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
    hexpand: true,
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
                self.children = Bluetooth.devices
                    .filter((d) => d.connected == false)
                    .map(device)
            })
        })
    ]
}) 


export const BluetoothConnectedDevices = () => Widget.Box({
    vertical: true,
    hexpand: true,
    // Hides this widget if no devices are connected
    visible: Bluetooth.bind("connectedDevices").as(v => {
        if (v.length > 0){
            return true
        }
        return false
    }),
    children: [
        Widget.Label({
            hpack: "start",
            label: "Connected devices",
        }),
        Widget.Scrollable({
            css: `
                min-height: 32px;
            `,
            child: Widget.Box({
                vertical: true,
            }).hook(Bluetooth, self => {
                self.children = Bluetooth.connectedDevices.map(device)
            })
        })

    ]
})

export const BluetoothMenu = () => Widget.Box({
    class_name: "container",
    children: [
        BluetoothConnectedDevices(),
        BluetoothDevices(),
    ],
})
    

export const BluetoothStatus = () => Widget.Box({
    children: [
        BluetoothButton(),
        Widget.Switch({
            vpack: "center",
            setup: (self) => {
                // Syncs the active property on this switch to the enabled property on the Bluetooth GObject
                self.bind_property("active", Bluetooth, "enabled",  GObject.BindingFlags.BIDIRECTIONAL)
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

export const Refresh = () => Widget.Button({
    class_name: "normal-button bg-button",
    // Scan for bt devices
    on_primary_click: () => execAsync("bluetoothctl --timeout 10 scan on"),
    child: Widget.Icon({
        size: 20,
        icon: icons.refresh,
    }),
})


export const BluetoothDevice = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label({
            hpack: "start",
            label: CurrentDevice.bind().as(d => d.name),
        }),
        Widget.Label({
            hpack: "start",
            label: CurrentDevice.bind().as(d => {
                if (d.paired != null){
                    return "Paired? " + d.paired.toString()
                }
                return "Paired? N/A"
            }),
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
        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => { 
                let device = Bluetooth.getDevice(CurrentDevice.value.address)
                device.paired = false
            },
            child: Widget.Label({
                label: "Remove"
            })
        }),
    ]
})




import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

export const BluetoothIcon = (edges) => Widget.Label().hook(Bluetooth, self  => {
    self.class_name = `${edges}`,
    console.log("edges" + edges)
    self.toggleClassName("dim", !Bluetooth.enabled)
    if(Bluetooth.enabled){
        self.label = "󰂯"
    }
    else{
        self.label = "󰂲"
    }
})

export function ToggleBluetooth(){
    console.log("bluetooth")
    console.log(Bluetooth.enabled)
    if(Bluetooth.enabled){
        Bluetooth.enabled = false
    }
    else{
        Bluetooth.enabled = true
    }
}

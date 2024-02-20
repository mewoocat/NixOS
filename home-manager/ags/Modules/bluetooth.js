
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

export const BluetoothIcon = () => Widget.Label().hook(Bluetooth, self  => {
    self.toggleClassName("dim", !Bluetooth.enabled)
    if(Bluetooth.enabled){
        self.label = "󰂯"
    }
    else{
        self.label = "󰂲"
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


import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

export const BluetoothIcon = () => Widget.Button({
    //class_name: "bluetooth-icon icon",
    hexpand: true,
    child:
        Widget.Label({
            label: Bluetooth.bind("enabled").transform(p => {
                if (p){
                    return "󰂯"
                }
                else{
                    return "󰂲"
                }
            }) 
        }),
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

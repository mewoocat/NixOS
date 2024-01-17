
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js'

export const BluetoothIcon = () => Widget.Box({
    class_name: "bluetooth-icon icon",
    children:[
        //Widget.Label().hook(Audio, self => {
        //}, 'speaker-changed'),
        Widget.Label({
            label: Bluetooth.bind("enabled").transform(p => {
                if (p){
                    return "󰂯"
                }
                else{
                    return "󰂲"
                }
            }) 
        })
    ]
})

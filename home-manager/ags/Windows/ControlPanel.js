
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { brightness } from '../Modules/brightness.js';
import { VolumeSlider } from '../Modules/volume.js';
import { WifiButton } from '../Modules/network.js';
import { BluetoothIcon } from '../Modules/bluetooth.js';
import { BatteryLabel } from '../Modules/battery.js';


function ControlPanelButton(widget, size) {
    const button = Widget.Button({
        child:
            widget
    })
    return button;
}


const container = () => Widget.Box({
    class_name: "control-panel-container",
    spacing: 8,
    vertical: true,
    children: [
        //Row
        Widget.Box({
           children:[
                ControlPanelButton(WifiButton()),
                ControlPanelButton(BluetoothIcon()),
                ControlPanelButton(BatteryLabel()),
           ]
        }),
        brightness(),
        VolumeSlider(),
    ],
});

export const ControlPanel = (monitor = 0) => Widget.Window({
    name: `ControlPanel`, // name has to be unique
    class_name: 'control-panel',
    visible: false,
    monitor,
    anchor: ['top', 'right', 'bottom'],
    exclusivity: 'normal',
    child: Widget.Box({
        children: [container()]
    }),
});
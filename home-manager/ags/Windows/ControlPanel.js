
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { brightness } from '../Modules/brightness.js';
import { VolumeSlider } from '../Modules/volume.js';
import { MicrophoneSlider } from '../Modules/microphone.js';
import { WifiButton } from '../Modules/network.js';
import { BluetoothIcon, ToggleBluetooth } from '../Modules/bluetooth.js';
import { BatteryLabel, BatteryCircle, BatteryWidgetLarge } from '../Modules/battery.js';
import { cpuLabel, cpuProgress, ramLabel, tempLabel , storageLabel, SystemStatsWidgetLarge} from '../Modules/system_stats.js';


// Make widget a formated button with action on click
function ControlPanelButton(widget, w, h, action) {
    const button = Widget.Button({
        class_name: "control-panel-button",
        vpack: "start",
        hpack: "start",
        on_clicked: action,
        css: `
            min-width: ${w}px;
            min-height: ${h}px;
        `,
        child:
            widget
    })
    return button;
}

// Make widget a formated box
function ControlPanelBox(widget, w, h) {
    const box = Widget.Box({
        class_name: "control-panel-button", // Make this a box class?
        vpack: "start",
        hpack: "start",
        css: `
            min-width: ${w}px;
            min-height: ${h}px;
        `,
        child:
            widget
    })
    return box;
}


const container = () => Widget.Box({
    class_name: "control-panel-container",
    spacing: 8,
    vertical: true,
    children: [
        //Rows

        Widget.Box({
           children:[
                Widget.Box({
                    vertical: true,
                    children: [
                        ControlPanelButton(WifiButton(), 128, 64, null),
                        ControlPanelButton(BluetoothIcon(), 64, 64, ToggleBluetooth),
                    ]
                }),
                ControlPanelButton(BatteryWidgetLarge(), 128, 128, null),
           ]
        }),
        brightness(),
        VolumeSlider(),
        MicrophoneSlider(),

        Widget.Box({
            children:[
                ControlPanelBox(SystemStatsWidgetLarge(), 128, 128),
            ]
        })
    ],
});

export const ControlPanel = (monitor = 0) => Widget.Window({
    name: `ControlPanel`, // name has to be unique
    class_name: 'control-panel',
    visible: false,
    focusable: true,
    popup: true,
    monitor,
    anchor: ['top', 'right'],
    exclusivity: 'normal',
    child: Widget.Box({
        children: [container()]
    }),
});
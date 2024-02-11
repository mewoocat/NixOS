
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { brightness } from '../Modules/brightness.js';
import { VolumeSlider } from '../Modules/volume.js';
import { MicrophoneSlider } from '../Modules/microphone.js';
import { WifiButton } from '../Modules/network.js';
import { BluetoothIcon, ToggleBluetooth } from '../Modules/bluetooth.js';
import { BatteryWidgetLarge } from '../Modules/battery.js';
import { SystemStatsWidgetLarge} from '../Modules/system_stats.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import options from '../options.js';
console.log("large = " + options.large)

export const ControlPanelToggleButton = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t ControlPanel'),
    child:
        Widget.Label({
            label: ""
        }) 
});

// Make widget a formated button with action on click
function ControlPanelButton(widget, w, h, action) {
    const button = Widget.Button({
        class_name: "control-panel-button",
        vpack: "start",
        hpack: "start",
        on_clicked: action,
        css: `
            min-width: ${w}rem;
            min-height: ${h}rem;
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
            min-width: ${w}rem;
            min-height: ${h}rem;
        `,
        child:
            widget
    })
    return box;
}


const container = () => Widget.Box({
    class_name: "control-panel-container",
    css: `margin: 1rem;`,
    spacing: 8,
    vertical: true,
    children: [
        //Rows

        Widget.Box({
           children:[
                Widget.Box({
                    vertical: true,
                    children: [
                        ControlPanelButton(WifiButton(), options.large, options.small, null),
                        ControlPanelButton(BluetoothIcon(), options.small, options.small, ToggleBluetooth),
                    ]
                }),
                ControlPanelButton(BatteryWidgetLarge(), options.large, options.large, null),
           ]
        }),
        brightness(),
        VolumeSlider(),
        MicrophoneSlider(),

        Widget.Box({
            children:[
                ControlPanelBox(SystemStatsWidgetLarge(), options.large, options.large),
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
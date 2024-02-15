
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { brightness } from '../Modules/brightness.js';
import { VolumeSlider } from '../Modules/volume.js';
import { MicrophoneSlider } from '../Modules/microphone.js';
import { WifiButton } from '../Modules/network.js';
import { BluetoothIcon, ToggleBluetooth } from '../Modules/bluetooth.js';
import { BatteryWidgetLarge } from '../Modules/battery.js';
import { SystemStatsWidgetLarge} from '../Modules/system_stats.js';
import { ThemeIcon } from '../Modules/theme.js'
import { PowerIcon } from '../Modules/power.js';

import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import options from '../options.js';

export const ControlPanelToggleButton = (monitor) => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync(`ags -t ControlPanel`),
    child:
        Widget.Label({
            label: ""
        }) 
});

// Make widget a formated button with action on click
function ControlPanelButton(widget, w, h, action) {
    const button = Widget.Button({
        class_name: `control-panel-button`,
        on_clicked: action,
        //hpack: "center",
        //vpack: "center",
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
        class_name: `control-panel-box`,
        //hpack: "center",
        //vpack: "center",
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
    css: `
        margin: 1rem;
        padding: 0.5rem;
    `,
    spacing: 8,
    vertical: true,
    children: [
        //Rows
        Widget.Box({
           children:[
                Widget.Box({
                    vertical: true,
                    children: [
                        Widget.Box({
                            children: [
                                ControlPanelButton(WifiButton("bottom"), options.large, options.small, null, ""),
                            ]
                        }),
                        Widget.Box({
                            children: [
                                ControlPanelButton(BluetoothIcon("top-right"), options.small, options.small, ToggleBluetooth),
                                ControlPanelButton(ThemeIcon("top-left"), options.small, options.small, null),
                            ]
                        })
                    ]
                }),
                ControlPanelBox(BatteryWidgetLarge("noEdge"), options.large, options.large),
           ]
        }),

        brightness(),
        VolumeSlider(),
        MicrophoneSlider(),

        Widget.Box({
            children:[
                ControlPanelBox(SystemStatsWidgetLarge("noEdge"), options.large, options.large),
                Widget.Box({
                    //css: `background-color: #ff0000;`,
                    vertical: true,
                    children: [
                        Widget.Box({
                            children: [
                                ControlPanelButton(PowerIcon("bottom-right"), options.small, options.small, ToggleBluetooth, ""),
                                ControlPanelButton(PowerIcon("bottom-left"), options.small, options.small, ToggleBluetooth, ""),
                            ]
                        }),
                        Widget.Box({
                            children: [
                                ControlPanelButton(PowerIcon("top-right"), options.small, options.small, ToggleBluetooth, ""),
                                ControlPanelButton(PowerIcon("top-left"), options.small, options.small, ToggleBluetooth, ""),
                            ]
                        })
                    ]
                })
            ]
        })
    ],
});

export const ControlPanel = Widget.Window({
    //name: `ControlPanel-${monitor}`, // name has to be unique
    name: `ControlPanel`,
    class_name: 'control-panel',
    visible: false,
    //keymode: "exclusive",
    popup: true,
    anchor: ['top', 'right'],
    exclusivity: 'normal',
    child: Widget.Box({
        children: [container()]
    }),
});
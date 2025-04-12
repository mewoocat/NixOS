import Widget from 'resource:///com/github/Aylur/ags/widget.js'

import * as Battery from '../Modules/Battery.js';
import * as Network from '../Modules/Network.js';
import * as Bluetooth from '../Modules/Bluetooth.js';
import * as Workspaces from '../Modules/Workspaces.js';
import * as Launcher from '../Windows/Launcher.js';
import * as Applications from '../Modules/Applications.js';
import * as Audio from '../Modules/Audio.js';
import * as ActivityCenter from './ActivityCenter.js';
import * as ControlPanel from './ControlPanel.js';
import * as Systray from '../Modules/Systray.js'
import * as NightLight from '../Modules/NightLight.js'
import * as Notification from '../Modules/Notification.js'


// layout of the bar
const Left = () => Widget.Box({
    spacing: 8,
    children: [
        Launcher.LauncherButton(),
        Applications.ToggleScratchpad(),
        Workspaces.Workspaces(),
        Applications.ClientIcon(),
        Applications.ClientTitle(),
    ],
});

const Center = () => Widget.Box({
    spacing: 4,
    hpack: "center",
    hexpand: true,
    children: [
        // This center box is used to have icons relative to the ActivityCenterButton 
        Widget.CenterBox({
            start_widget: Widget.Box({
                css: `min-width: 1.6rem;`,
            }),
            center_widget: ActivityCenter.ActivityCenterButton(),
            end_widget: Widget.Box({
                css: `min-width: 1.6rem;`,
                hpack: "end",
                children: [
                    Notification.NotifCountBarIcon(),
                ],
            }),
        })
    ],
});

const Right = (monitor) => Widget.Box({
    hpack: 'end',
    spacing: 24,
    children: [
        //Battery.BatteryBarButton(),
        Systray.SysTray(), 
        Battery.BatteryLabel(), 
        Notification.DndBarIcon(),
        NightLight.BarIcon(),
        Audio.MicrophoneIcon(),
        Network.NetworkIndicator(),
        Bluetooth.BluetoothIcon(),
        Audio.VolumeIcon(),
        ControlPanel.ControlPanelToggleButton(monitor),
    ],
});

export const Bar = (monitor = 0) => Widget.Window({
    name: `bar`,
    class_name: 'bar-window',
    monitor: monitor,
    anchor: ['top', 'left', 'right'],
    layer: "overlay",
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(monitor),
    }),
});



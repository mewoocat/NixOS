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
    spacing: 8,
    children: [
        ActivityCenter.ActivityCenterButton(),
    ],
});

const Right = (monitor) => Widget.Box({
    hpack: 'end',
    spacing: 24,
    children: [
        //Battery.BatteryBarButton(),
        Systray.SysTray(), 
        Battery.BatteryLabel(), 
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
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(monitor),
    }),
});



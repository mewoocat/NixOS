import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Import Modules
import { BatteryLabel } from '../Modules/battery.js';
import { VolumeIcon } from '../Modules/volume.js';
import { WifiIcon, EthernetIcon} from '../Modules/network.js';
import { BluetoothIcon } from '../Modules/bluetooth.js';
import { Workspaces } from '../Modules/workspaces.js';
import { LauncherButton } from '../Windows/Launcher.js';
import { ClientTitle, ClientIcon } from '../Modules/CurrentClient.js';
import { MicrophoneIcon } from '../Modules/microphone.js';
import { ActivityCenterButton } from './ActivityCenter.js';
import { ControlPanelToggleButton } from './ControlPanel.js';
import { SysTray } from '../Modules/systray.js'


// layout of the bar
const Left = () => Widget.Box({
    spacing: 8,
    children: [
        LauncherButton(),
        Workspaces(),
        ClientIcon(),
        ClientTitle(),
    ],
});

const Center = () => Widget.Box({
    spacing: 8,
    children: [
        ActivityCenterButton(),
    ],
});

const Right = (monitor) => Widget.Box({
    hpack: 'end',
    spacing: 12,
    children: [
        SysTray(), 
        EthernetIcon(),
        BluetoothIcon(),
        BatteryLabel(), 
        MicrophoneIcon(),
        WifiIcon(),
        VolumeIcon(),
        ControlPanelToggleButton(monitor),
    ],
});

export const bar = (monitor = 0) => Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        class_name: "bar-container",
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(monitor),
    }),
});



import Widget from 'resource:///com/github/Aylur/ags/widget.js';

// Import Modules
import { BatteryLabel } from '../Modules/Battery.js';
import { VolumeIcon } from '../Modules/Volume.js';
import { WifiIcon, EthernetIcon} from '../Modules/Network.js';
import { BluetoothIcon } from '../Modules/Bluetooth.js';
import { Workspaces, SpecialWorkspace } from '../Modules/Workspaces.js';
import { LauncherButton } from '../Windows/Launcher.js';
import { ClientTitle, ClientIcon } from '../Modules/CurrentClient.js';
import { MicrophoneIcon } from '../Modules/Microphone.js';
import { ActivityCenterButton } from './ActivityCenter.js';
import { ControlPanelToggleButton } from './ControlPanel.js';
import { SysTray } from '../Modules/Systray.js'


// layout of the bar
const Left = () => Widget.Box({
    spacing: 8,
    children: [
        LauncherButton(),
        Workspaces(),
        ClientIcon(),
        ClientTitle(),
        //SpecialWorkspace(),
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
        Widget.Separator({
            vertical: true,
        }),
        EthernetIcon(),
        BluetoothIcon(),
        BatteryLabel(), 
        MicrophoneIcon(),
        WifiIcon(true, null),
        VolumeIcon(),
        ControlPanelToggleButton(monitor),
    ],
});

export const Bar = (monitor = 0) => Widget.Window({
    name: `bar`,
    class_name: 'bar-window',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(monitor),
    }),
});



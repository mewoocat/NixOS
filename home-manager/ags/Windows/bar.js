import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Import Modules
import { BatteryLabel } from '../Modules/battery.js';
import { VolumeIcon } from '../Modules/volume.js';
import { WifiIcon } from '../Modules/network.js';
import { BluetoothIcon } from '../Modules/bluetooth.js';
import { Workspaces } from '../Modules/workspaces.js';
import { Launcher } from '../Modules/launcher.js';
import { ClientTitle, ClientIcon } from '../Modules/CurrentClient.js';
import { Notification } from '../Modules/notification.js';
import { MicrophoneIcon } from '../Modules/microphone.js';
import { ActivityCenterButton } from './ActivityCenter.js';



const ControlPanel = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t ControlPanel'),
    child:
        Widget.Label({
            label: ""
        }) 
});

// layout of the bar
const Left = () => Widget.Box({
    spacing: 8,
    children: [
        Launcher(),
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

const Right = () => Widget.Box({
    hpack: 'end',
    spacing: 8,
    children: [
        //SysTray(), // See comments at func. declaration
        MicrophoneIcon(),
        BatteryLabel(), 
        BluetoothIcon(),
        WifiIcon(),
        VolumeIcon(),
        ControlPanel(),
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
        end_widget: Right(),
    }),
});

import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

// Does this just watch for css changes to then reload them?
monitorFile(
    `${App.configDir}/style.css`,
    function() {
        App.resetCss();
        App.applyCss(`${App.configDir}/style.css`);
    },
);

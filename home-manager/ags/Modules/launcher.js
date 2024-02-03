import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'

export const Launcher = () => Widget.Button({
    class_name: 'launcher',
    on_primary_click: () => execAsync('ags -t applauncher'),
    child:
        Widget.Label({
            label: ""
        })
});
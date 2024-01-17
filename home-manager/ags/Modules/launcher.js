import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const Launcher = () => Widget.Button({
    class_name: 'launcher',
    cursor: "pointer",
    on_primary_click: () => execAsync('ags -t applauncher'),
    child:
        Widget.Label({
            label: ""
        })
});
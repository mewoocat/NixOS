
import Widget from 'resource:///com/github/Aylur/ags/widget.js';



const test = () => Widget.Box({
    class_name: "control-panel-container",
    spacing: 8,
    children: [
        Widget.Label({
            label: "BBBBB"
        }) 
    ],
});

export const ControlPanel = (monitor = 0) => Widget.Window({
    name: `ControlPanel`, // name has to be unique
    class_name: 'control-panel',
    visible: false,
    monitor,
    anchor: ['top', 'right', 'bottom'],
    exclusivity: 'normal',
    child: Widget.Box({
        children: [test()]
    }),
});
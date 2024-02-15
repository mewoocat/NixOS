import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const ThemeIcon = (edges) => Widget.Box({
    class_name: `${edges}`,
    hexpand: true,
    child:
        Widget.Label({
            label: ""
        })
})
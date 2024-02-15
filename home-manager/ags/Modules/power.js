import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const PowerIcon = (edges) => Widget.Box({
    class_name: `${edges}`,
    hexpand: true,
    vpack: "fill",
    hpack: "fill",
    child:
        Widget.Label({
            vpack: "center",
            hpack: "center",
            label: "p"
        })
})
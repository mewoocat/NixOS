import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { cpu, ram, /*temp,*/ storage } from '../variables.js';

export const cpuLabel = () => Widget.Label({
    label: cpu.bind().transform(value => " " + Math.round(value*100).toString() + "%"),
})

export const ramLabel = () => Widget.Label({
    label: ram.bind().transform(value => " " + Math.round(value*100).toString() + "%"),
})

/*
export const tempLabel = () => Widget.Label({
    label: temp.bind().transform(value => " " + Math.round(value).toString() + "°C"),
})*/

export const storageLabel = () => Widget.Label({
    label: storage.bind().transform(value => "  " + value + "%"),
})


export const cpuProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    value: cpu.bind()
});

export const ramProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    value: ram.bind()
});

export const storageProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    value: storage.bind().transform(p => p / 100)
});

/*
export const tempProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    value: cpu.bind()
});*/

export const SystemStatsWidgetLarge = (edges) => Widget.Box({
    class_name: `${edges}`,
    hexpand: true,
    children: [
        Widget.Box({
            vertical: true,
            hpack: "center",
            vpack: "center",
            children: [
                // CPU
                Widget.Box({
                    children: [
                        cpuProgress,
                        cpuLabel(),
                    ]
                }),
                // RAM
                Widget.Box({
                    children: [
                        ramProgress,
                        ramLabel(),
                    ]
                }),
                // Storage
                Widget.Box({
                    children: [
                        storageProgress,
                        storageLabel(),
                    ]
                }),
                // Temp
                /*Widget.Box({
                    children: [
                        tempProgress,
                        tempLabel(),
                    ]
                }),*/
            ]
        }),
    ]
})
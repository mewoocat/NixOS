import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

export const uptime = Variable("...", {
    poll: [60000, 'uptime', out => out.split(',')[0]]
});

const divide = ([total, free]) => free / total;

const GPUTemp = Variable(0, {
    poll: [1000, ['bash', '-c', "gpustat --no-header | grep '\[0\]' | cut -d '|' -f 2 | cut -d ',' -f 1 | cut -c -3"], out => Math.round(parseInt(out))/100]
    //poll: [1000, ['bash', '-c', ""], out => Math.round(parseInt(out))/100]
})

const cpu = Variable(0, {
    poll: [1000, ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"], out => Math.round(out)/100]
})

const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

// Cpu temp
const temp = Variable(-1, {
    poll: [6000, ['bash', '-c', "fastfetch --packages-disabled nix --logo none --cpu-temp | grep 'CPU:' | rev | cut -d ' ' -f1 | cut -c 4- | rev"], out => Math.round(out)
]});

// Percent of storage used on '/' drive
//TODO -t ext4 is a workaround the "df: /run/user/1000/doc: Operation not permitted" error which is returning a non zero value which might be causing it not to work
export const storage = Variable(0, {
    poll: [5000, 'df -h -t ext4', out => out.split('\n')
        .find(line => line.endsWith("/"))
        .split(/\s+/).slice(-2)[0]
        .replace('%', '')
    ]
});

export const cpuLabel = () => Widget.Label({
    label: cpu.bind().transform(value => " " + Math.round(value*100).toString() + "%"),
})

export const ramLabel = () => Widget.Label({
    label: ram.bind().transform(value => " " + Math.round(value*100).toString() + "%"),
})

export const tempLabel = () => Widget.Label({
    label: temp.bind().transform(value => " " + value.toString() + "°C"),
})

export const storageLabel = () => Widget.Label({
    label: storage.bind().transform(value => "  " + value + "%"),
})


export const cpuProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    start_at: 0.25,
    rounded: true,
    value: cpu.bind()
});

export const ramProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    start_at: 0.25,
    rounded: true,
    value: ram.bind()
});

export const storageProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    start_at: 0.25,
    rounded: true,
    value: storage.bind().transform(p => p / 100)
});

export const tempProgress = Widget.CircularProgress({
    class_name: "system-stats-circular-progress",
    start_at: 0.25,
    rounded: true,
    value: temp.bind().as(v => v / 100)
});

export const SystemStatsWidgetLarge = (w, h) => Widget.Box({
    class_name: "control-panel-button", // The reason this doesn't highlight on hover is because it's a box not a button
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    hexpand: true,
    children: [
        Widget.Box({
            vertical: true,
            hexpand: true,
            hpack: "center",
            vpack: "center",
            spacing: 4,
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
                Widget.Box({
                    children: [
                        tempProgress,
                        tempLabel(),
                    ]
                }),
            ]
        }),
        /*
        Widget.Box({
            hpack: "center",
            vpack: "center",
            hexpand: true,
            children: [

                Widget.Label({
                    label: uptime.bind(),
                }),
            ],
        }),
        */
    ]
})


export const GPUCircle = (w, h) => Widget.CircularProgress({
    hpack: "center",
    class_name: "battery-circle",
    start_at: 0.25,
    rounded: true,
    value: GPUTemp.bind().transform(p => p),

})

export const GPULabel = () => Widget.Box({
    hpack: "center",
    children: [
        Widget.Icon({
            icon: "freon-gpu-temperature-symbolic",
        }),
        Widget.Label({
            label: GPUTemp.bind().transform(p => " " + Math.round(p * 100) + "°C"),
        }),
    ],
})

export const GPUWidget = (w, h) => Widget.Box({ 
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    class_name: `control-panel-button`,
    children: [
        Widget.Overlay({
            hexpand: true,
            child:
                GPUCircle(),
            overlays: [
                GPULabel(),
            ]
        })
    ]
})


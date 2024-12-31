import Variable from 'resource:///com/github/Aylur/ags/variable.js'

import icons from '../icons.js'


const StatIcon = (icon, size) => Widget.Icon({
    hpack: "center",
    size: size,
    icon: icon,
})

export const uptime = Variable("...", {
    poll: [60000, 'uptime', out => out.split(',')[0]]
});

const divide = ([total, free]) => free / total;

// Todo: make this only poll if dgpu is detected
const GPUTemp = Variable(0, {
    poll: [2000, ['bash', '-c', "gpustat --no-header | grep '\[0\]' | cut -d '|' -f 2 | cut -d ',' -f 1 | cut -c -3"], out => Math.round(parseInt(out))/100]
    //poll: [1000, ['bash', '-c', ""], out => Math.round(parseInt(out))/100]
})

const cpu = Variable(0, {
    poll: [2000, ['bash', '-c', "top -bn 1 | awk '/Cpu/{print 100-$8}'"], out => Math.round(out)/100]
})

const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
});

const ramAmount = Variable(0, {
    poll: [2000, 'free --kibi', out => {
        const GBinKiB = 0.000001024
        const memArray = out.split('\n')
                 .find(line => line.includes('Mem:'))
                 .split(/\s+/)
        const total = Math.round(memArray[1] * GBinKiB * 10) / 10 // Round to 1 decimal place
        const used = Math.round(memArray[2] * GBinKiB * 10 ) / 10 // Round to 1 decimal place  
        const formatedOut = `Usage: ${used} GB / ${total} GB`
        return formatedOut
    }
]});

// Cpu temp
const temp = Variable(-1, {
    poll: [6000, ['bash', '-c', "fastfetch --packages-disabled nix --logo none --cpu-temp | grep 'CPU:' | rev | cut -d ' ' -f1 | cut -c 4- | rev"], out => Math.round(out)
]});

// Percent of storage used on '/' drive
export const storage = Variable(0, {
    poll: [5000, 'df /', out => { 
        const storageArray = out.split('\n')
                          .find(line => line.endsWith("/"))
                          .split(/\s+/)
        const total = storageArray[1]
        const available = storageArray[3]
        const used = total - available
        const usage = Math.round(used / total * 100000) / 100000 // Round to 5 decimal places
        print(usage)
        return usage
    }]
});

export const storageAmount = Variable(0, {
    // Get root storage
    // df outputs amounts in 1024 byte units
    poll: [5000, 'df /', out => {
        const GBinKiB = 0.000001024
        const storageArray = out.split('\n')
                          .find(line => line.endsWith("/"))
                          .split(/\s+/)
        const total = Math.round(storageArray[1] * GBinKiB * 10) / 10 // Round to 1 decimal place
        const available = Math.round(storageArray[3] * GBinKiB * 10) / 10 // Round to 1 decimal place
        const used = total - available
        const storageFormatted = `Usage of /: ${used} GB / ${total} GB`
        return storageFormatted
    }]
});

export const cpuLabel = () => Widget.Label({
    class_name: "sub-text",
    label: cpu.bind().transform(value => "" + Math.round(value*100).toString() + "%"),
})

export const ramLabel = () => Widget.Label({
    class_name: "sub-text",
    label: ram.bind().transform(value => "" + Math.round(value*100).toString() + "%"),
})

export const tempLabel = () => Widget.Label({
    class_name: "sub-text",
    label: temp.bind().transform(value => "" + value.toString() + "°C"),
})

export const storageLabel = () => Widget.Label({
    class_name: "sub-text",
    label: storage.bind().transform(value => "" + Math.round(value * 100) + "%"),
})

export const cpuProgress = Widget.ProgressBar({
    css: `
        margin: 0.2rem;
    `,
    hpack: "center",
    vertical: true,
    inverted: true,
    value: cpu.bind(),
});

export const ramProgress = Widget.ProgressBar({
    css: `
        margin: 0.2rem;
    `,
    hpack: "center",
    vertical: true,
    inverted: true,
    value: ram.bind()
});

export const storageProgress = Widget.ProgressBar({
    css: `
        margin: 0.2rem;
    `,
    hpack: "center",
    vertical: true,
    inverted: true,
    value: storage.bind()
});

export const tempProgress = Widget.ProgressBar({
    css: `
        margin: 0.2rem;
    `,
    hpack: "center",
    vertical: true,
    inverted: true,
    value: temp.bind().as(v => v / 100)
});

export const systemStatsBox2x2 = Widget.Box({
    hexpand: true,
    hpack: "center",
    vpack: "center",
    spacing: 10,
    children: [
        // Temp
        Widget.Box({
            tooltip_text: temp.bind().transform(value => "CPU temp: " + value.toString() + "°C"),
            vertical: true,
            hpack: "center",
            children: [
                tempProgress,
                tempLabel(),
                StatIcon(icons.cpuTemp, 16),
            ]
        }),
        // CPU
        Widget.Box({
            tooltip_text: cpu.bind().transform(value => "CPU usage: " + Math.round(value*100).toString() + "%"),
            vertical: true,
            hpack: "center",
            children: [
                cpuProgress,
                cpuLabel(),
                StatIcon(icons.cpu, 16),
            ]
        }),
        // RAM
        Widget.Box({
            tooltip_text: ramAmount.bind(),
            vertical: true,
            hpack: "center",
            children: [
                ramProgress,
                ramLabel(),
                StatIcon(icons.ram, 16),
            ]
        }),
        // Storage
        Widget.Box({
            tooltip_text: storageAmount.bind(),
            vertical: true,
            hpack: "center",
            children: [
                storageProgress,
                storageLabel(),
                StatIcon(icons.storage, 20),
            ]
        }),
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
    class_name: `control-panel-box`,
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


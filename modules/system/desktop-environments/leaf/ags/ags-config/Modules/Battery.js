import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js'
import * as Common from '../Lib/Common.js'


export function isAvailable(){
    return Battery.available
}

export const BatteryLabel = () => Widget.Box({
    visible: Battery.bind('available'),
    tooltip_text: Battery.bind('time-remaining').as(v => `Time remaining: ${Common.SecToHourAndMin(v)}`),

    hpack: "center",
    children: [
        // Percent
        Widget.Label({
            label: Battery.bind('percent').transform(p => {
                return p.toString() + "% "
            })
        }),

        //Icon
        Widget.Overlay({
            class_name: "battery icon",
            child: Widget.Label({
                class_name: "battery-bg",
                label: Battery.bind('charging').transform(p => {
                    if (p){
                        return ""
                    }
                    return ""
                })
            }),
            overlays: [
                Widget.Label({
                    class_name: "battery-fg"
                }).hook(Battery, label => {
                    //print("bat: " + Battery.energy + " W")
                    
                    //label.toggleClassName("battery-fg-low", Battery.percent < 21 && Battery.charging == false)
                    label.toggleClassName("battery-fg-low", false)

                    if (Battery.charging){
                        label.label = ""
                    }
                    else if (Battery.percent > 80){
                        label.label = ""
                    }
                    else if (Battery.percent> 60){
                        label.label = ""
                    }
                    else if (Battery.percent > 40){
                        label.label = ""
                    }
                    else if (Battery.percent > 20){
                        label.label = ""
                    }
                    else{
                        label.label = ""
                    }
                }, 'changed'),
            ]
        }),

    ],
});


export const BatteryCircle = () => Widget.CircularProgress({
    hpack: "center",
    class_name: "battery-circle",
    start_at: 0.25,
    rounded: true,
    value: Battery.bind("percent").transform(p => p / 100),
})

export const BatteryWidget = (w, h) => Widget.Box({ 
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    class_name: `control-panel-box`,
    children: [
        Widget.Overlay({
            visible: Battery.bind('available'),
            hexpand: true,
            child:
                BatteryCircle(),
            overlays: [
                BatteryLabel(),
            ]
        }),
    ]
})

const batteryMenu = Widget.Menu({
    children: [
        // Seems to cause gc errors
        /*
        Widget.MenuItem({
            //child: BatteryCircle(),
        }),
        */
    ],
})

export const BatteryBarButton = () => Widget.Button({
    class_name: "normal-button",
    child: BatteryLabel(),
    on_primary_click: (_, event) => batteryMenu.popup_at_pointer(event),
})

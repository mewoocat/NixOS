import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';


export const BatteryLabel = () => Widget.Box({
    visible: Battery.bind('available'),
    hpack: "center",
    children: [

        Widget.Label({
            label: Battery.bind('percent').transform(p => {
                return p.toString() + "% "
            })
        }),


        Widget.Overlay({
            class_name: "battery icon",
            child:
                Widget.Label({
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
                    })
                    .hook(Battery, label => {
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
    class_name: "battery-circle",
    value: Battery.bind("percent").transform(p => p / 100),
})

export const BatteryWidgetLarge = (edges) => Widget.Box({ 
    //visible: Battery.bind('available'),
    class_name: `${edges}`,
    hexpand: true,
    children: [
        Widget.Overlay({
            child:
                BatteryCircle(),
            overlays: [
                BatteryLabel(),
            ]
        })
    ]
})
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';


export const BatteryLabel = () => Widget.Box({
    visible: Battery.bind('available'),
    hpack: "center",
    children: [

        Widget.Label({
            // Not sure what transform does here 
            label: Battery.bind('percent').transform(p => {
                return p.toString() + "% "
            })
        }),


        Widget.Overlay({
            class_name: "battery icon",
            child:
                Widget.Label({
                    class_name: "battery-bg",
                    // Not sure what transform does here 
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
                            //change color
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

export const BatteryWidgetLarge = () => Widget.Overlay({
    child:
        BatteryCircle(),
    overlays: [
        BatteryLabel(),
    ]
})
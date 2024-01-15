import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

export const BatteryLabel = () => Widget.Box({
    class_name: 'battery',
    visible: Battery.bind('available'),
    children: [

        Widget.Overlay({
            child:
                Widget.Label({
                    // Not sure what transform does here 
                    label: Battery.bind('percent').transform(p => {
                        return ""
                    })
                }),
            overlays: [
                Widget.Label({
                    // Not sure what transform does here 
                    label: Battery.bind('percent').transform(p => {
                        return ""
                    })
                }),
            ]
        }),

        Widget.Label({
            // Not sure what transform does here 
            label: Battery.bind('percent').transform(p => {
                return p.toString()
            })
        }),
    ],
});
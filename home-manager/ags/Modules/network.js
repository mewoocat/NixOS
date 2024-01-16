import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';


export const WifiIcon = () => Widget.Box({
    class_name: "wifi-icon icon",
    children:[
        Widget.Overlay({
          child:
            Widget.Label({
                class_name: "wifi-bg",
                label: ""
            }),
          overlays: [
            Widget.Label({
                class_name: "wifi-fg",
                label: Network.wifi.bind('strength').transform(p => {
                    console.log(p)
                    if (p>75){
                        return ""
                    }
                    else if (p > 50){
                        return ""
                    }
                    else if (p>25){
                        return ""  
                    }
                    else if (p>=0){
                        return ""
                    }
                    else {
                        return ""
                    }
                })
            }),
          ]  
        })
    ]
})

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

const WifiSSID = () => Widget.Box({
    children:[
        Widget.Label({
            label: Network.wifi.bind("ssid")
        }).hook(Network, label =>{
            if (Network.wifi.internet == "disconnected" || Network.wifi.internet == "connecting"){
                label.label = Network.wifi.internet
            }
            else{
                label.label = Network.wifi.ssid
            }
        })
    ]
})

export const WifiButton = () => Widget.Box({
    class_name: "wifi-button",
    children:[
        WifiIcon(),
        WifiSSID(),
    ]
})

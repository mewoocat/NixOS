import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';



export const WifiIcon = () => Widget.Box({
    class_name: "wifi-icon icon",
    children:[
        Widget.Overlay({
          child:
            Widget.Label().hook(Network, self => {
                self.class_name = "dim"
                self.toggleClassName('invisible', Network.wifi.strength < 0)
                self.label = ""
            }),
          overlays: [
            Widget.Label().hook(Network, self => {
                self.class_name = "wifi-fg"
                self.toggleClassName('dim', Network.wifi.strength < 0)
                var p = Network.wifi.strength
                if (p>75){
                    self.label = ""
                }
                else if (p > 50){
                    self.label = ""
                }
                else if (p>25){
                    self.label = ""  
                }
                else if (p>=0){
                    self.label = ""
                }
                else {
                    self.label = ""
                }

            }),
          ]  
        })
    ]
})

export const EthernetIcon = () => Widget.Box({
    class_name: "icon",
    children:[
        Widget.Label().hook(Network, self => {
            self.class_name = "ethernet-icon"
            var status = Network.wired.internet
            self.toggleClassName('dim', status == "disconnected")
            if (status == "disconnected"){
                self.label = ""
            }
            else {
                self.label = ""
            }
        }),
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
    class_name: `wifi-button`,
    hexpand: true,
    children:[
        WifiIcon(),
        WifiSSID(),
    ]
})

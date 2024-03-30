import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import { ControlPanelTab } from '../variables.js';


// isConnected: bool // ap: AcessPoint Object //
export const WifiIcon = (isConnected, ap) => Widget.Box({
    class_name: "wifi-icon icon",
    children:[
        Widget.Overlay({
          child:
            Widget.Label().hook(Network, self => {
                self.class_name = "dim"

                // If network is connected
                if (isConnected) {
                    self.toggleClassName('invisible', Network.wifi.strength < 0)
                }
                // Or an access point
                else {
                    self.toggleClassName('invisible', ap.strength < 0)
                }

                self.label = ""
            }),
          overlays: [
            Widget.Label().hook(Network, self => {
                self.class_name = "wifi-fg"
                var strength = -1

                // If network is connected
                if (isConnected) {
                    strength = Network.wifi.strength
                }
                // Or an access point
                else {
                    strength = ap.strength
                }

                self.toggleClassName('dim', strength < 0)

                if (strength>75){
                    self.label = ""
                }
                else if (strength > 50){
                    self.label = ""
                }
                else if (strength>25){
                    self.label = ""  
                }
                else if (strength>=0){
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

export const EthernetIconLabel = () => Widget.Box({
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

export const EthernetIcon = () => Widget.Icon({
    class_name: "icon",
    icon: "network-wired-offline-symbolic"

}).hook(Network, self => {
    var status = Network.wired.internet
    self.toggleClassName('dim', status == "disconnected")
    if (status == "disconnected"){
        self.icon = "network-wired-offline-symbolic"
    }
    else {
        self.icon = "network-wired-symbolic"
    }
})

export const WifiSSID = () => Widget.Box({
    children:[
        Widget.Label({
            label: Network.wifi.bind("ssid"),
            truncate: "end",
            maxWidthChars: 8,
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

export const WifiButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    hexpand: true,
    onClicked: () => ControlPanelTab.setValue("network"),
    child: Widget.Box({
        children:[
            WifiIcon(true, null),
            WifiSSID(),
        ]
    }),
})

const network = ap => Widget.Button({ 
    child: Widget.Box({
        children: [
            WifiIcon(false, ap),
            Widget.Label({
                label: ap.ssid,
            })
        ],
    })
})

Network.wifi.scan()
var networks = Network.wifi.accessPoints.map(network)
var net = Network.wifi.accessPoints
print("nets --___---------------__-_-----_______----_")
for (let i = 0; i < net.length; i++){
    print(net[i].ssid)
}



export const WifiList = () => Widget.Scrollable({
    css: `
        min-height: 400px;
    `,
    child: Widget.Box({
        vertical: true,
        children: networks,
    })
})
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import { ControlPanelTab, APInfoVisible, CurrentAP } from '../variables.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'

// Globals
var networks = []

// Not sure if this works
export const RefreshWifi = (ap) => Widget.Button({ 
    class_name: "normal-button",
    onPrimaryClick: () => {
        networks = []
        Network.wifi.scan()

        print(Network.wifi.iconName)
    }, 
    child: Widget.Icon({
        icon: "view-refresh-symbolic",
    }),
})

// Font glyph backup
/*
// isConnected: bool // ap: AcessPoint Object //
export const WifiIcon = (isConnected, ap) => Widget.Button({
    //class_name: "normal-button",
    child: Widget.Box({
        class_name: "wifi-icon icon",
        children:[
            Widget.Overlay({
                child: Widget.Label().hook(Network, self => {
                    self.class_name = "dim"

                    // If network is connected
                    if (isConnected) {
                        self.toggleClassName('invisible', Network.wifi.strength < 0)
                    }
                    // Or an access point
                    else if (ap != null) {
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
                        else if (ap != null) {
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
})
*/

export const WifiIcon = (isConnected, ap) => Widget.Button({
    //class_name: "normal-button",
    child: Widget.Icon({
        size: 16,
    }).hook(Network, self => {

        // If network is connected
        if (isConnected) {
            self.toggleClassName('invisible', Network.wifi.strength < 0)
        }
        // Or an access point
        else if (ap != null) {
            self.toggleClassName('invisible', ap.strength < 0)
        }

        self.icon = Network.wifi.iconName
    })
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
    size: 20,
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

// Shows ethernet if connected else shows wifi
export const NetworkIndicator = () => Widget.Box({
}).hook(Network, self => {
    let status = Network.wired.internet
    if (status == "connected" ){
        self.children = [ EthernetIcon() ]
    }
    else{
        self.children = [ WifiIcon(true, null) ]
    }

    // Need to show the child since widget are hidden by default 
    // and widget is added after the Button's initlization.
    // This is not needed with the Box as it automatically shows new widgets
    self.child.visible = true
    //self.show_all() // ^
}) 

export const WifiSSID = () => Widget.Box({
    children:[
        Widget.Label({
            label: Network.wifi.bind("ssid"),
            truncate: "end",
            //maxWidthChars: 8,
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
    onClicked: () => {
        ControlPanelTab.setValue("network")
    },
    child: Widget.Box({
        class_name: "control-panel-button-content",
        children:[
            WifiIcon(true, null),
            WifiSSID(),
        ]
    }),
})

export const WifiSecurity = () => Widget.Icon({
    //TODO
    //visibility: 
    icon: "lock-symbolic",
})


const network = (ap) => Widget.Button({ 
    class_name: "normal-button",
    onPrimaryClick: () => {
        APInfoVisible.value = true
        //ControlPanelTab.setValue("ap"),
        print(ap.strength)

        // Set ap point info
        CurrentAP.value = ap 
    }, 
    child: Widget.CenterBox({
        startWidget: Widget.Label({
            hpack: "start",
            label: ap.ssid
        }),
        endWidget: Widget.Box({
            hpack: "end",
            children: [
                Widget.Label({label: ap.strength.toString()}),
                WifiSecurity(),
                WifiIcon(false, ap),
            ],
        }),
    })
})

export const APInfo = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label().hook(CurrentAP, self => {
            self.label = CurrentAP.value.ssid
        }),
        Widget.Label({ label: "Frequency: " + CurrentAP.value.frequency || "N/A" }),
        Widget.Label({ label: "Strength: " + CurrentAP.value.strength || "N/A" }),

        // Delete connection
        // nmcli connection delete <ssid>

        // Password entry
        Widget.Entry({
            class_name: "app-entry",
            placeholder_text: "Password",
            hexpand: true,
            visibility: false,
            on_accept: ({ text }) => {
                let ssid = CurrentAP.value.ssid
                let password = text
                print(ssid)
                print(password)
                execAsync(`nmcli dev wifi connect ${ssid} password ${password}`) 
            },
        }),
    ]
})

//Network.wifi.scan()
//var networks = Network.wifi.accessPoints.map(network)

export const WifiList = () => Widget.Scrollable({
    css: `
        min-height: 100px;
    `,
    vexpand: true,
    child: Widget.Box({
        vertical: true,
        children: [],
    }).poll(10000, self => {
        try{
            //TODO: Sort not working
            //networks = Network.wifi.accessPoints.sort((a, b) => {a.strength - b.strength}).map(network)
            networks = Network.wifi.accessPoints
                .filter((ap) => ap.ssid != Network.wifi.ssid) // Filter out connected ap
                .sort((a, b) => b.strength - a.strength)    // Sort by signal strength (I think lamba functions without {} imply a return)
                .map(network) 
        }
        catch{ 
            networks = []
        }
        self.children = networks
    })
})






















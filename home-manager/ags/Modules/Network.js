import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import { ControlPanelTab, APInfoVisible, CurrentAP } from '../variables.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js'

// Globals
var apPassword = ""

// Not sure if this works
export const RefreshWifi = (ap) => Widget.Button({ 
    class_name: "normal-button",
    onPrimaryClick: () => {
        Network.wifi.scan()
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


export const WifiIcon = (isConnected, ap) => Widget.Icon({
    size: 16,
}).hook(Network, self => {

    // If access point
    if (ap != null) {
        self.icon = ap.iconName
    }
    // If cuurently connected network
    else{
        self.icon = Network.wifi.iconName
    } 
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

export const WifiPanelButton = (w, h) => Widget.Button({
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


const currentNetwork = () => Widget.Button({ 
    visible: Network.wifi.bind("internet").as(v => {
        if (v != "disconnected"){
            return true
        }
        return false
    }),
    class_name: "normal-button",
    onPrimaryClick: () => {
        // Set ap point info
        CurrentAP.value = Network.wifi
        // Set tab
        ControlPanelTab.setValue("ap")
    }, 
    child: Widget.CenterBox({
        startWidget: Widget.Box({
            children: [
                Widget.Label({
                    css: "color: green; font-size: 20px;",
                    label: "✓ ",
                }),
                Widget.Label({
                    hpack: "start",
                    label: Network.wifi.bind("ssid"),
                }),
            ]
        }),
        endWidget: Widget.Box({
            hpack: "end",
            children: [
                WifiSecurity(),
                WifiIcon(false, Network.wifi),
            ],
        }),
    })
})

const network = (ap) => Widget.Button({ 
    class_name: "normal-button",
    onPrimaryClick: () => {
        // Set ap point info
        CurrentAP.value = ap 
        // Hide error 
        connectError.visible = false 
        // Set tab
        ControlPanelTab.setValue("ap")
    }, 
    child: Widget.CenterBox({
        startWidget: Widget.Label({
            hpack: "start",
            label: ap.ssid
        }),
        endWidget: Widget.Box({
            hpack: "end",
            children: [
                WifiSecurity(),
                WifiIcon(false, ap),
            ],
        }),
    })
})

function ConnectToAP(ssid, password){

    execAsync(`nmcli dev wifi connect ${ssid} password ${password}`)
        //.then(out => print(out))
        .catch(err => {
            print(err)
            connectError.visible = true
        });
}

const connectError = Widget.Label({
    css: `color: red;`,
    wrap: true,
    maxWidthChars: 24,
    label: "Connection Failed: Invalid password or network failure"
}).on("realize", self => self.visible = false) // Set label as invisible by default since 
                                               // adding it to a box will automatically make
                                               // it visible even if the property says false for visible


// Password entry
const passwordEntry = Widget.Entry({
    class_name: "app-entry",
    placeholder_text: "Password",
    hexpand: true,
    visibility: false,
    on_accept: (self) => {
        ConnectToAP(CurrentAP.value.ssid, self.text)
        self.text = "" 
    },
    // Set password to use with connect button
    on_change: ({ text }) => {
        connectError.visible = false // Hide error when typing a new password
        apPassword = text
    },
})

export const APInfo = () => Widget.Box({
    vertical: true,
    children: [
        Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "SSID: " + CurrentAP.value.ssid.toString()}),
        Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "Frequency: " + CurrentAP.value.frequency.toString()}),
        Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "Strength: " + CurrentAP.value.strength.toString()}),
        //Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "Address: " + CurrentAP.value.address.toString()}),
        //Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "BSSID: " + CurrentAP.value.bssid.toString()}),
        //Widget.Label({hpack: "start"}).hook(CurrentAP, self => {self.label = "Last Seen: " + CurrentAP.value.lastSeen.toString()}),

        passwordEntry,
        connectError, 
        // Connect button
        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => { 
                ConnectToAP(CurrentAP.value.ssid, apPassword)
                passwordEntry.text = ""
            },
            child: Widget.Label({
                label: "Connect"
            })
        }),

        // Delete connection
        Widget.Button({
            class_name: "normal-button",
            onPrimaryClick: () => { 
                let ssid = CurrentAP.value.ssid
                execAsync(`nmcli connection delete ${ssid}`) 
            },
            child: Widget.Label({
                label: "Remove"
            })
        })
    ]
})

export const WifiListAvailable = () => Widget.Scrollable({
    css: `
        min-height: 100px;
    `,
    vexpand: true,
    child: Widget.Box({
        vertical: true,
        children: [],
    }).hook(Network, self => {
        self.children = Network.wifi.accessPoints
            .filter((ap) => ap.ssid != Network.wifi.ssid) // Filter out connected ap
            .sort((a, b) => b.strength - a.strength)    // Sort by signal strength (I think lamba functions without {} imply a return)
            .map(network) 
    })
})

export const WifiList = () => Widget.Box({
    vertical: true,
    children: [
        currentNetwork(),
        Widget.Separator({
            class_name: "horizontal-separator",
            vertical: false,
        }),
        WifiListAvailable(),
    ]
})






















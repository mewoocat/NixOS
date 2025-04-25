import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import * as Helper from '../Lib/Helper.ts'


//const prefix = "1"  // Identifier for minimized workspace

function getMinimizedWS(maximizedWS){
    //return parseInt(prefix + maximizedWS)
    return -maximizedWS
}

function getMaximizedWS(minimizedWS){
    //return parseInt(minimizedWS.toString().substring(prefix.length))
    return -minimizedWS
}

function isMinimized(ws){
    /*
    ws = ws.toString()
    if (ws.length > 3 || ws.slice(0, prefix.length) == prefix){
        return true 
    }
    else{
        return false
    }
    */
    if (ws < 0){
        return true
    }
    return false
}


const toggleClient = (client) => {

    // If minimized
    if (isMinimized(client.workspace.id)){ 
        var maximizedWS = getMaximizedWS(client.workspace.id)
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${maximizedWS},address:${client.address}`)
        // Focus window
        //Hyprland.messageAsync(`dispatch focuswindow address:${client.address}`)
        Hyprland.messageAsync(`dispatch alterzorder top,address:${client.address}`)
    }
    
    // If maximized
    else{
        var minimizedWS = getMinimizedWS(client.workspace.id)
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${minimizedWS},address:${client.address}`)
    }
    
}

const Client = (client = null) => Widget.Box({ 
    // Attributes
    attribute: {
        returnWS: client.workspace,
    }, 
})


const appButton = (client = null) => Widget.Button({
    class_name: "normal-button",
    tooltip_text: client.title,
    on_primary_click: () => toggleClient(client),
    child: Widget.Box({
        vertical: true,
        children: [
            Widget.Box({
                children: [
                    Widget.Box({
                        class_name: "dock-app-indicator",
                        vpack: "center",
                        setup: (self) => {
                            self.hook(Hyprland, () => {
                                //self.toggleClassName("dock-button-current", Hyprland.active.client.address === client.address)
                                self.toggleClassName("dock-app-indicator-active", Hyprland.active.client.address === client.address)
                            }, 'event')
                        }
                    }),
                    Widget.Icon({
                        class_name: 'client-icon',
                        css: 'font-size: 2rem;',
                        icon: Helper.lookupClientIcon(client.class),
                    }),         
                ],
            }),
            Widget.Label({
                label: Helper.formatClientName(client.class),
                class_name: 'small-text',
                truncate: 'end',
                maxWidthChars: 8,
            })                
        ],
    }),
});

const clientList = Widget.Scrollable({
    hscroll: "never",
    child: Widget.Box({
        class_name: "dock-container",
        css: "min-height: 6rem;",
        css: "min-width: 4rem;",
        vertical: true,
    }).hook(Hyprland, self => {
        //check if ws is empty
        self.children = Hyprland.clients.filter(client => client.class != "" &&
            (client.workspace.id === Hyprland.active.workspace.id || 
                client.workspace.id === getMinimizedWS(Hyprland.active.workspace.id))).map(client => {
            return appButton(client)
        })
    })
})

export const Dock = (monitor = 0) => Widget.Window({
    name: `Dock`, // name has to be unique
    monitor,
    visible: true,
    //margins: [4,64,4,64],
    //margins: [8,8,8,8],
    anchor: ['bottom', 'left', 'top'],
    exclusivity: 'exclusive',
    child: clientList,
});

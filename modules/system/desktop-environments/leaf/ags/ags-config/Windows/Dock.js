import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import * as Helper from '../Lib/Helper.ts'
import * as Log from '../Lib/Log.js'


//const prefix = "1"  // Identifier for minimized workspace
const prefix = "special:minimized-"  // Identifier for minimized workspace

function getMinimizedWS(maximizedWS){
    //return parseInt(prefix + maximizedWS)
    return `${prefix + maximizedWS}`
}

function getMaximizedWS(minimizedWS){
    //return parseInt(minimizedWS.toString().substring(prefix.length))
    // Remove the prefix
    return minimizedWS.toString().replace(prefix, "")
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
    Log.Info(`isMinimized(): ws = ${ws}`)
    ws = ws.toString()
    if (ws.startsWith(prefix)){
        return true
    }
    return false
}


const toggleClient = (client) => {

    Log.Info(`Client JSON: ${JSON.stringify(client)}`)

    // If minimized
    if (isMinimized(client.workspace.name)){ 
        const maximizedWS = getMaximizedWS(client.workspace.name)
        Log.Info(`Window is minimized.  Maximizing: moving from ${client.workspace.name} ${maximizedWS}}`)
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${maximizedWS}, address:${client.address}`)
        // Focus window
        //Hyprland.messageAsync(`dispatch focuswindow address:${client.address}`)
        Hyprland.messageAsync(`dispatch alterzorder top,address:${client.address}`)
        client.workspace.name = maximizedWS
    }
    
    // If maximized
    else{
        /*
        var minimizedWS = getMinimizedWS(client.workspace.id)
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${minimizedWS},address:${client.address}`)
        */
        const minimizedWS = `${prefix + client.workspace.name}`
        Log.Info(`Window is maximized.  Minimizing: moving from ${client.workspace.name} ${minimizedWS}}`)
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${minimizedWS}, address:${client.address}`)
        client.workspace.name = minimizedWS
    }
    
}

const appButton = (client = null) => Widget.Box({
    attribute: {
        client: client
    },
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

        Widget.Button({
            class_name: "normal-button",
            tooltip_text: client.title,
            on_primary_click_release: (self) => {
                toggleClient(client)
                // Update the client state
                //self.parent.attribute.client = Hyprland.getClient(self.parent.attribute.client.address)
            },
            child: Widget.Box({
                vertical: true,
                children: [
                    Widget.Box({
                        children: [
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
                ]
            })
        })
    ]
})


const clientList = Widget.Box({
    class_name: "dock-container",
    css: "min-height: 6rem;",
    css: "min-width: 6rem;",
    vertical: true,
    // Initalize the clients on the active workspace
    children: Hyprland.clients.filter(client => client.class != "" && (
        client.workspace.id === Hyprland.active.workspace.id || 
        client.workspace.name === getMinimizedWS(Hyprland.active.workspace.id)
    )).map(client => appButton(client))
// Note that the signal method args are tacked onto the self arg (i think)
}).hook(Hyprland, (self, name, data) => {
    //check if ws is empty
    /*
    const clients = Hyprland.clients.filter(client => client.class != "" && (
        client.workspace.id === Hyprland.active.workspace.id || 
        client.workspace.name === getMinimizedWS(Hyprland.active.workspace.id)
    )) 
    */
    // Only update if "needed"
    // Warning: this causes issues with showing/hiding
    /*
    if (
        clients.length !== self.children.length ||
        !clients.every((client, index) => {
            return client.pid === self.children[index].attribute.client.pid
        })
    ) {
        //Log.Info("dock children updated")
        //self.children = clients.map(client => appButton(client))
    }
    self.children = clients.map(client => appButton(client))
    */

    // If client was added
    if (name === "openwindow") {
        const address = "0x" + data.split(',')[0]
        const newClient = Hyprland.getClient(address)
        self.add(appButton(newClient))
    }
    
    // If client was removed
    else if (name === "closewindow") {
        Log.Info(`closeWindow event`)
        Log.Info(`closewindow data = ${data}`)
        const address = "0x" + data.split(',')[0]
        for (const client of self.children) {
            if (client.attribute.client.address === address) {
                self.remove(client)
                client.destroy()
                break
            }
        }
    }

    // If workspace changed
    else if (name === "workspace" || name === "workspacev2") {
        Log.Info("workspace event")
        Log.Info(`window data = ${data}`)
        const clients = Hyprland.clients.filter(client => client.class != "" && (
            client.workspace.id === Hyprland.active.workspace.id || 
            client.workspace.name === getMinimizedWS(Hyprland.active.workspace.id)
        )) 
        self.children = clients.map(client => appButton(client))
    }
    
    // If client was moved to the current workspace
    else if (name === "movewindow") {
        //Log.Info(`movewindow data = ${data}`)
    }

    // Some other event occured
    else {
        //Log.Info(`Some other event occured\n\tname = ${name}\n\tdata = ${data}`)
    }

}, "event") // Hyprland IPC events

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

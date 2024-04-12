
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';


const minimizedWorkspace = 98

const focusClient = (client) => {

    console.log("CLIENT:")
    console.log(client)

    // If maximized
    if (client.workspace.id != minimizedWorkspace){ 
        console.log("maximized" + client.address) 
        Hyprland.messageAsync(`dispatch movetoworkspacesilent ${minimizedWorkspace},address:${client.address}`)
    }
    // If minimized
    else{
        Hyprland.messageAsync(`dispatch movetoworkspacesilent 1,address:${client.address}`)
        console.log("minimized")
    }
    
    // Focus window
    //Hyprland.messageAsync(`dispatch focuswindow address:${client.address}`)
}

const Client = (client = null) => Widget.Box({
    
    // Attributes
    attribute: {
        returnWS: client.workspace,
    },


    
})


const appButton = (client = null) => Widget.Button({
    class_name: "dock-button",
    tooltip_text: client.class,
    on_primary_click: () => focusClient(client),


    child:
        Widget.Box({
            vertical: true,
            children: [
                Widget.Icon({
                    class_name: 'client-icon',
                    css: 'font-size: 3rem;',
                    icon: client.class,
                }),
                
                Widget.Label({
                    label: client.class,
                    truncate: 'end',
                    maxWidthChars: 8,
                })
                
            ]
        }),
    setup: (self) => {
        self.hook(Hyprland, () => {
            self.toggleClassName("dock-button-current", Hyprland.active.client.address === client.address)
        }, 'event')
    }
});

const clientList = Widget.Scrollable({
    hscroll: "never",
    child:
        Widget.Box({
            class_name: "dock-container",
            css: "min-height: 6rem;",
            css: "min-width: 6rem;",
            vertical: true,
            
            //children:
                // Returns the list of clients as buttons
                /*
                Hyprland.bind("clients").transform(clients => clients.map(client => {
                    if (client.class != "" && client.workspace.id == Hyprland.active.workspace.id){
                        return appButton(client)
                    }
                }))
                */

                /* This has same issue as hook below
                Utils.watch([], Hyprland, "event", (clients) => {
                    return Hyprland.clients.filter(client => client.class != "" && client.workspace.id === Hyprland.active.workspace.id).map(client => {
                        return appButton(client)
                    })
                })
                */
            
        }).hook(Hyprland, self => {
            //check if ws is empty

            self.children = Hyprland.clients.filter(client => client.class != "" && client.workspace.id === Hyprland.active.workspace.id).map(client => {
                return appButton(client)
            })
        })

        /* This hook is borked as it stops updating if no clients are in the current workspace
        .hook(Hyprland, self => {
            //check if ws is empty

            self.children = Hyprland.clients.filter(client => client.workspace.id === Hyprland.active.workspace.id).map(client => {
                return appButton(client)
            })
        })
        */
})

export const Dock = (monitor = 0) => Widget.Window({
    name: `Dock`, // name has to be unique
    monitor,
    visible: false,
    //margins: [4,64,4,64],
    //margins: [8,8,8,8],
    anchor: ['bottom', 'left', 'top'],
    exclusivity: 'exclusive',
    child: clientList,
});

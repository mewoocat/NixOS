
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

const focusClient = ({address}) => Hyprland.sendMessage(`dispatch focuswindow address:${address}`)

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
                /*
                Widget.Label({
                    label: client.class,
                })
                */
            ]
        })
});

const clientList = Widget.Box({
    class_name: "dock-container",
    css: "min-height: 5rem;",
    css: "min-width: 6rem;",
    //vertical: true,
    children:
        // Returns the list of clients as buttons
        Hyprland.bind("clients").transform(clients => clients.map(client => {
            return appButton(client)
        })
    )
});

export const Dock = (monitor = 0) => Widget.Window({
    name: `Dock`, // name has to be unique
    monitor,
    visible: false,
    margins: [0,64,8,64],
    //margins: [8,0,8,8],
    anchor: ['bottom', 'left', 'right'],
    exclusivity: 'exclusive',
    child: clientList,
});
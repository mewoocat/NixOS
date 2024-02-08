
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

const appButton = (client = null) => Widget.Button({
    class_name: "dock-button",
    child:
        Widget.Box({
            vertical: true,
            children: [
                Widget.Icon({
                    class_name: 'client-icon',
                    css: 'font-size: 2rem;',
                    icon: client.class,
                }),
                Widget.Label({
                    label: client.class,
                })
            ]
        })
});

const clientList = Widget.Box({
    class_name: "container",
    css: "min-height: 5rem;",
    children:
        // Returns the list of clients as buttons
        Hyprland.bind("clients").transform(clients => clients.map(client => {
            console.log(client.class)
            return appButton(client)
        })
    )
});

export const Dock = (monitor = 0) => Widget.Window({
    name: `Dock`, // name has to be unique
    class_name: 'bar',
    monitor,
    anchor: ['bottom', 'left', 'right'],
    exclusivity: 'exclusive',
    child: clientList,
});
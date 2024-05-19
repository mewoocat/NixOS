
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Clock, Calendar } from '../Modules/DateTime.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { NotificationWidget } from './Notification.js';
import { Media } from '../Modules/Media.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { CloseOnClickAway } from '../Common.js';
import { Weather } from '../Modules/Weather.js';

//grid.attach(Widget, col, row, width, height)
import Gtk from 'gi://Gtk';
const grid = new Gtk.Grid()
grid.attach(Calendar, 1, 1, 1, 1)
grid.attach(Weather(12, 12), 1, 2, 1, 1)
grid.attach(NotificationWidget(24,12), 2, 1, 1, 1)
grid.attach(Media, 2, 2, 1, 1)


const container = () => Widget.Box({
    class_name: "",
    css: `
        padding: 1px;
    `,
    child: Widget.Revealer({
        revealChild: false,
        transitionDuration: 150,
        transition: 'slide_down',
        setup: self => {
            self.hook(App, (self, windowName, visible) => {
                if (windowName === "ActivityCenter"){
                    self.revealChild = visible
                }
            }, 'window-toggled')
        },
        child: Widget.Box({
            class_name: 'toggle-window',
            spacing: 8,
            children: [
                grid,
                /*
                Widget.Box({
                    hpack: "start",
                    hexpand: false,
                    children: [
                        grid,
                    ],
                }),
                Widget.Box({
                    hexpand: true,
                    vertical: true,
                    children: [
                        Media,
                        NotificationWidget,
                    ]
                })
                */
            ],
        })
    })
});


export const ActivityCenterButton = () => Widget.Button({
    class_name: 'launcher normal-button',
    on_primary_click: () => execAsync('ags -t ActivityCenter'),
    child: Clock()
});

export const ActivityCenter = (monitor = 0) => Widget.Window({
    name: `ActivityCenter`, // name has to be unique
    visible: false,
    monitor,
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    exclusivity: 'normal',
    child: CloseOnClickAway("ActivityCenter", container(), "top-center"),
});

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Gtk from 'gi://Gtk';

import * as DateTime from '../Modules/DateTime.js';
import * as Notification from '../Modules/Notification.js';
import * as Common from '../Common.js';
import * as Weather from '../Modules/Weather.js';
import * as Media from '../Modules/Media.js'
import * as ControlPanel from './ControlPanel.js'
import * as Global from '../Global.js';


// Usage: grid.attach(Widget, col, row, width, height)
const grid = Global.Grid()
grid.attach(DateTime.CalendarContainer(12, 12), 1, 1, 1, 1)
grid.attach(ControlPanel.ControlPanelBox(Weather.Weather(), 12, 12), 1, 2, 1, 1)

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

                // Reset calendar date to today
                Utils.execAsync(['date', '+%e %m %Y'])
                    .then(date => {
                        date = date.split(" ")
                        const day = date[0]
                        const month = date[1] - 1 // Because the month is zero indexed
                        const year = date[2]
                        DateTime.Calendar.select_day(day) // Reset the selected day
                        DateTime.Calendar.select_month(month, year) // Reset the selected month and year
                    })
                    .catch(err => print(err))

            }, 'window-toggled')
        },
        child: Widget.Box({
            class_name: 'toggle-window',
            spacing: 8,
            vexpand: false,
            vertical: true,
            children: [
                Widget.Box({
                    children: [
                        grid,
                        Widget.Box({
                            vertical: true,
                            children: [
                                Notification.NotificationWidget(24,12),
                            ],
                        }),
                    ],
                }),
                Media.Media(), // Need to optimize
            ],
        })
    })
});

export const ActivityCenterButton = () => Widget.Button({
    class_name: 'launcher normal-button',
    on_primary_click: () => Utils.execAsync('ags -t ActivityCenter'),
    child: DateTime.Clock()
});

export const ActivityCenter = (monitor = 0) => Widget.Window({
    name: `ActivityCenter`, // name has to be unique
    css: `background-color: unset;`,
    visible: false,
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top"], // Debug
    exclusivity: 'normal',
    child: Common.CloseOnClickAway("ActivityCenter", container(), "top-center"),
});

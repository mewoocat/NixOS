
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Clock, Calendar, CalendarContainer } from '../Modules/DateTime.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { NotificationWidget } from '../Modules/Notification.js';
import { Media } from '../Modules/Media.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { CloseOnClickAway } from '../Common.js';
import { Weather } from '../Modules/Weather.js';

//grid.attach(Widget, col, row, width, height)
import Gtk from 'gi://Gtk';
const grid = new Gtk.Grid()
grid.attach(CalendarContainer(12, 12), 1, 1, 1, 1)
grid.attach(Weather(12, 12), 1, 2, 1, 1)
//grid.attach(NotificationWidget(24,12), 2, 1, 1, 1)
//grid.attach(Media, 2, 2, 1, 1)


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
                execAsync(['date', '+%e %m %Y'])
                    .then(date => {
                        date = date.split(" ")
                        const day = date[0]
                        const month = date[1] - 1 // Because the month is zero indexed
                        const year = date[2]
                        Calendar.select_day(day) // Reset the selected day
                        Calendar.select_month(month, year) // Reset the selected month and year
                    })
                    .catch(err => print(err))

            }, 'window-toggled')
        },
        child: Widget.Box({
            class_name: 'toggle-window',
            spacing: 8,
            vexpand: false,
            children: [
                grid,
                NotificationWidget(24,12),
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
    //anchor: ["top"], // Debug
    exclusivity: 'normal',
    child: CloseOnClickAway("ActivityCenter", container(), "top-center"),
});

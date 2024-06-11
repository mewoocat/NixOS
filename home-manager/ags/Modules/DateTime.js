import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const Clock = () => Widget.Label({
    class_name: 'clock',
    setup: self => self
        .poll(1000, self => execAsync(['date', '+%B %e   %l:%M %P'])
            .then(date => self.label = date)),
});


// More info https://aylur.github.io/ags-docs/config/subclassing-gtk-widgets/ ?
export const Calendar = Widget.Calendar({ 
    showDayNames: false,
    showHeading: true,
    hpack: "center",
    vpack: "center",
});

export const CalendarContainer = (w, h) => Widget.Box({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    children: [
        Calendar,
    ],
})

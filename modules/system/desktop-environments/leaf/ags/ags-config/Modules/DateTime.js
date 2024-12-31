import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import GLib from 'gi://GLib'


// Contains datetime object
const datetime = Variable(GLib.DateTime.new_now_local(), {
    // Poll every 60s
    poll: [60000, () => GLib.DateTime.new_now_local()],
})

export const Clock = () => Widget.Label({
    class_name: 'clock',
    label: datetime.bind().as(v => {
        return v.format("%B %e   %l:%M %P")
    }),
});



// More info https://aylur.github.io/ags-docs/config/subclassing-gtk-widgets/ ?
export const Calendar = Widget.Calendar({ 
    showDayNames: false,
    showHeading: true,
    hpack: "center",
    vpack: "center",
});

export const CalendarContainer = (w, h) => Widget.Box({
    class_name: "control-panel-box",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    children: [
        Calendar,
    ],
})

// TODO: Delete this file?

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
export const Notification = () => Widget.Box({
    class_name: 'notification',
    visible: Notifications.bind('popups').transform(p => p.length > 0),
    children: [
        Widget.Icon({
            icon: 'preferences-system-notifications-symbolic',
        }),
        Widget.Label({
            label: Notifications.bind('popups').transform(p => p[0]?.summary || ''),
        }),
    ],
});

export const dndToggle = Widget.Button({
    class_name: "normal-button",
    onPrimaryClick: () => Notifications.dnd = !Notifications.dnd,
    child: Widget.Icon({
        size: 20,
        icon: Notifications.bind("dnd").as(v => {
            if (v){
                return "notifications-disabled-symbolic"
            }
            return "notification-symbolic"
        })
    })
})

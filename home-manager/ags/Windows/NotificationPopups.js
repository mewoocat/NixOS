import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Notification } from '../Modules/Notification.js';

export const NotificationPopup = Widget.Window({
    name: 'notifications',
    anchor: ['bottom', 'right'],
    child: Widget.Box({
        css: `padding: 1px;`,
        children: [
            //Widget.Label({label: "close all"}),
            Widget.Box({
                class_name: 'notifications',
                vertical: true,
                spacing: 10,
                children: Notifications.bind('popups').transform(popups => {
                    return popups.map(Notification);
                }),
            }),
        ]
    })
});

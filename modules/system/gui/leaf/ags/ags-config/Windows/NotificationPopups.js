import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Notification } from '../Modules/Notification.js';

// Window in which popup notifications are displayed
export const NotificationPopup = () => Widget.Window({
    name: 'notifications',
    anchor: ['bottom', 'right'],
    css: `background-color: unset;`,
    child: Widget.Box({
        css: `padding: 1px;`,
        children: [
            Widget.Box({
                vertical: true,
                children: Notifications.bind('popups').transform(popups => {
                    return popups.map(Notification);
                }),
            }),
        ]
    })
});

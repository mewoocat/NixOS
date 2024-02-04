import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon } from 'resource:///com/github/Aylur/ags/utils.js';

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
const NotificationIcon = ({ app_entry, app_icon, image }) => {
    if (image) {
        return Widget.Box({
            css: `
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
        });
    }

    let icon = 'dialog-information-symbolic';
    if (lookUpIcon(app_icon))
        icon = app_icon;

    if (app_entry && lookUpIcon(app_entry))
        icon = app_entry;

    return Widget.Icon(icon);
};

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
export const Notification = n => {
    const icon = Widget.Box({
        vpack: 'start',
        class_name: 'icon',
        child: NotificationIcon(n),
    });

    const title = Widget.Label({
        class_name: 'title',
        xalign: 0,
        justification: 'left',
        hexpand: true,
        max_width_chars: 24,
        truncate: 'end',
        wrap: true,
        label: n.summary,
        use_markup: true,
    });

    const body = Widget.Label({
        class_name: 'body',
        hexpand: true,
        use_markup: true,
        xalign: 0,
        justification: 'left',
        label: n.body,
        wrap: true,
    });

    const actions = Widget.Box({
        class_name: 'actions',
        children: n.actions.map(({ id, label }) => Widget.Button({
            class_name: 'action-button',
            on_clicked: () => n.invoke(id),
            hexpand: true,
            child: Widget.Label(label),
        })),
    });

    return Widget.EventBox({
        on_primary_click: () => n.dismiss(),
        child: Widget.Box({
            class_name: `notification ${n.urgency}`,
            vertical: true,
            children: [
                Widget.Box({
                    children: [
                        icon,
                        Widget.Box({
                            vertical: true,
                            children: [
                                title,
                                body,
                            ],
                        }),
                    ],
                }),
                actions,
            ],
        }),
    });
};

export const NotificationWidget = Widget.Box({
    vertical: true,
    children: [
        Widget.Button({
            on_primary_click: () => Notifications.clear(),
            child: Widget.Label({label: "close all"}),
        }),
        Widget.Scrollable({
            hscroll: 'never',
            vscroll: 'always',
            css: 'min-height: 200px;',
            child: Widget.Box({
                class_name: 'notifications',
                vertical: true,
                spacing: 8,
                children: Notifications.bind('notifications').transform(notifications => {
                    return notifications.map(Notification).reverse();
                }),
            }),
        }),
    ]
});

export const NotificationPopup = Widget.Window({
    name: 'notifications',
    anchor: ['bottom', 'right'],
    css: 'background-color: #000000',
    child: Widget.Box({
        children: [
            Widget.Label({label: "close all"}),
            Widget.Box({
                class_name: 'notifications',
                vertical: true,
                children: Notifications.bind('popups').transform(popups => {
                    return popups.map(Notification);
                }),
            }),
        ]
    })
});
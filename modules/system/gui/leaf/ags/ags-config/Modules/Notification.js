import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import GLib from 'gi://GLib'


// Notification service config
Notifications.clearDelay = 100 // Helps prevent crashes when calling `Notifications.clear()`

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
const NotificationIcon = ({ app_entry, app_icon, image }) => {
    if (image) {
        return Widget.Box({
            css: `
                min-width: 3rem;
                min-height: 3rem;
                background-image: url("${image}");
                background-size: contain;
                background-repeat: no-repeat;
                background-position: center;
            `,
        });
    }

    let icon = 'dialog-information-symbolic';
    if (app_entry && Utils.lookUpIcon(app_entry))
        icon = app_entry;
    else if (Utils.lookUpIcon(app_icon))
        icon = app_icon;

    print("INFO: Notification icon: " + icon)

    return Widget.Icon({
        size: 48, 
        icon: icon,
    });
};

/** @param {import('resource:///com/github/Aylur/ags/service/notifications.js').Notification} n */
export const Notification = n => {
    const icon = Widget.Box({
        vpack: 'center',
        class_name: 'icon',
        child: NotificationIcon(n),
    });

    const appName = Widget.Label({
        class_name: 'sub-text',
        xalign: 0,
        justification: 'left',
        hexpand: true,
        max_width_chars: 24,
        truncate: 'end',
        wrap: true,
        label: n.app_name,
        use_markup: true,
    });

    const time = Widget.Label({
        class_name: 'sub-text',
        xalign: 1, // Move text to end of container
        justification: 'right',
        hexpand: true,
        max_width_chars: 24,
        truncate: 'end',
        label: GLib.DateTime.new_from_unix_local(n.time).format("%l:%M %P"),
    });

    const summary = Widget.Label({
        class_name: 'medium-text',
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
        class_name: 'small-text',
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
            class_name: "normal-button",
            class_name: 'action-button',
            on_clicked: () => n.invoke(id),
            hexpand: true,
            child: Widget.Label(label),
        })),
    });

    return Widget.EventBox({
        on_primary_click: () => n.dismiss(),
        child: Widget.Box({
            class_name: `${n.urgency} container`,
            vertical: true,
            //vpack: "center",
            //vexpand: true,
            css: `
                min-width: 16em;
                min-height: 4em;
            `,
            children: [
                Widget.Box({
                    spacing: 8,
                    children: [
                        icon,
                        Widget.Box({
                            vertical: true,
                            children: [
                                Widget.Box({
                                    homogeneous: true,
                                    children: [
                                        appName,
                                        time,
                                    ]
                                }),
                                summary,
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

export const NotificationWidget = (w,h) => Widget.Box({
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    vertical: true,
    children: [
        Widget.CenterBox({
            startWidget: Widget.Label({
                label: "Notifications",
            }),
            centerWidget: dndToggle,
            endWidget: Widget.Button({
                class_name: "normal-button",
                on_primary_click: () => Notifications.clear(),
                child: Widget.Label({label: "close all"}),
            }),
        }),
        Widget.Separator({class_name: "horizontal-separator"}),
        Widget.Scrollable({
            hscroll: 'never',
            vscroll: 'always',
            css: 'min-height: 140px;',
            vpack: 'fill',
            vexpand: true,
            child: Widget.Box({
                class_name: 'notifications',
                vertical: true,
                spacing: 8,
                children: Notifications.bind('notifications').transform(notifications => {
                    if (notifications.length == 0){
                        return [
                            Widget.Box({
                                vexpand: true,
                                children: [
                                    Widget.Label({
                                        vpack: "center",
                                        hexpand: true,
                                        class_name: "sub-text",
                                        label: "All caught up :)",
                                    })
                                ]
                            })
                        ]
                    }
                    return notifications.map(Notification).reverse();
                }),
            }),
        }),
    ]
});

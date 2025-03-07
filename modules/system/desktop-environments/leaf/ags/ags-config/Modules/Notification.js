import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import GLib from 'gi://GLib'
import Gio from 'gi://Gio';

import * as Common from '../Lib/Common.js';
import icons from '../icons.js';
import colors from '../colors.js';

// Notification service config
Notifications.clearDelay = 100 // Helps prevent crashes when calling `Notifications.clear()`

const NotificationIcon = ({ app_entry, app_icon, image }) => {
    if (image != null) {
        const imageFile = Gio.File.new_for_path(image)
        const imageExists = imageFile.query_exists(null)
        if(imageExists){
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
    }

    let icon = 'dialog-information-symbolic';
    if (app_entry && Utils.lookUpIcon(app_entry))
        icon = app_entry;
    else if (Utils.lookUpIcon(app_icon))
        icon = app_icon;

    //print("INFO: Notification icon: " + icon)

    return Widget.Icon({
        size: 48, 
        icon: icon,
    });
};

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
        css: `
            margin-right: 0.6em;
        `,
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

    const close = Common.CircleButton(icons.close, n.close, [], 1.4)

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
            //class_name: `${n.urgency} container`,
            class_name: `control-panel-box`,
            vertical: true,
            css: `
                padding: 1rem;
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
                                    children: [
                                        appName,
                                        time,
                                        close,
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

export const NotifCountBarIcon = () => Widget.Box({
    hpack: "center",
    vpack: "center",
    visible: Notifications.bind('notifications').as(v => {
        if (v.length > 0){
            return true
        }
        return false
    }),
    css: `
        background-color: ${colors.critical};
        min-height: 1.4rem;
        min-width: 1.4rem;
        font-size: 0.8rem;
        font-weight: bold;
        border-radius: 1.4rem;
    `,
    child: Widget.Label({
        hexpand: true,
        vexpand: true,
        hpack: "center",
        vpack: "center",
        class_name: "notif-count-bar-icon",
        label: Notifications.bind('notifications').as(v => {
            if (v.length >= 100) {
                return " 99+ "
            }
            return " " + v.length.toString() + " "
        })
    })
})

export const DndBarIcon = () => Widget.Icon({
    size: 20,
    visible: Notifications.bind('dnd'),
    tooltip_text: "Do not disturb is on",
    icon: icons.notificationDisabled,
    css: `
        color: red;
    `,
})

export const dndToggle = () => Widget.Button({
    class_name: "normal-button bg-button",
    onPrimaryClick: () => Notifications.dnd = !Notifications.dnd,
    child: Widget.Icon({
        size: 18,
        icon: Notifications.bind("dnd").as(v => {
            if (v){
                return icons.notificationDisabled
            }
            return icons.notification
        })
    })
})

const closeAllNotifButton = () => Widget.Button({
    class_name: "normal-button bg-button",
    //on_primary_click: () => Notifications.clear(), // Can cause crashes
    on_primary_click: ClearNotifications, // Can cause crashes
    //child: Widget.Label({label: "close all"}),
    child: Widget.Icon({
        size: 18,
        icon: icons.close
    }),
})

function ClearNotifications(){
    Notifications.notifications.forEach(notif => {
        try{ 
            notif.close()
            print(`INFO: Closed notification: ${notif.id}`)
        }
        catch(err){
            print(`ERROR: ${err}`)
        }
    }) 
}

export const NotificationWidget = (w,h) => Widget.Box({
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    vertical: true,
    children: [
        Widget.CenterBox({
            css: `
                padding-left: 1rem;
                padding-right: 0.4rem;
            `,
            hexpand: true,
            startWidget: Widget.Label({
                hpack: "start",
                className: "dim",
                label: "Notifications",
            }),
            centerWidget: null,
            endWidget: Widget.Box({
                hexpand: true,
                hpack: "end",
                children: [
                    dndToggle(),
                    closeAllNotifButton(),
                ],
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

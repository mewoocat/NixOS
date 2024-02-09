import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const WINDOW_NAME = 'applauncher';

/** @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app */
const AppItem = app => Widget.Button({
    class_name: "app-item",
    on_clicked: () => {
        App.closeWindow(WINDOW_NAME);
        app.launch();
    },
    attribute: { app },
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: app.icon_name || '',
                size: 42,
            }),
            Widget.Label({
                class_name: 'title',
                label: app.name,
                xalign: 0,
                vpack: 'center',
                truncate: 'end',
            }),
        ],
    }),
});

//
const powerButtons = Widget.Box({
    children: [
        Widget.Button({
            child: Widget.Label({label: "⏻"}),
            on_primary_click: () => execAsync('shutdown now'),
        }),
        Widget.Button({
            child: Widget.Label({label: ""}),
            on_primary_click: () => execAsync('systemctl hibernate'),
        }),
        Widget.Button({
            child: Widget.Label({label: "⏾"}),
            on_primary_click: () => execAsync('systemctl suspend'),
        }),
        Widget.Button({
            child: Widget.Label({label: ""}),
            on_primary_click: () => execAsync('systemctl reboot'),
        }),
    ]
})

const Applauncher = ({ width = 500, height = 500, spacing = 12 }) => {
    // list of application buttons
    let applications = Applications.query('').map(AppItem);

    // container holding the buttons
    const list = Widget.Box({
        vertical: true,
        children: applications,
        spacing,
    });

    // repopulate the box, so the most frequent apps are on top of the list
    function repopulate() {
        applications = Applications.query('').map(AppItem);
        list.children = applications;
    }

    // search entry
    const entry = Widget.Entry({
        class_name: "app-entry",
        hexpand: true,
        css: `margin-bottom: ${spacing}px;`,

        // to launch the first item on Enter
        on_accept: ({ text }) => {
            applications = Applications.query(text || '');
            if (applications[0]) {
                App.toggleWindow(WINDOW_NAME);
                console.log(applications[0].app)
                applications[0].launch();
            }
        },

        // filter out the list
        on_change: ({ text }) => applications.forEach(item => {
            item.visible = item.attribute.app.match(text);
        }),
    });

    return Widget.Box({
        class_name: "applauncher",
        vertical: true,
        css: `margin: ${spacing * 2}px;`,
        children: [
            entry,

            // wrap the list in a scrollable
            Widget.Scrollable({
                hscroll: 'never',
                css: `
                    min-width: ${width}px;
                    min-height: ${height}px;
                `,
                child: list,
            }),
            powerButtons,
        ],
        setup: self => self.hook(App, (_, windowName, visible) => {
            if (windowName !== WINDOW_NAME)
                return;

            // when the applauncher shows up
            if (visible) {
                repopulate();
                entry.text = '';
                entry.grab_focus();
            }
        }),
    });
};

// there needs to be only one instance
export const applauncher = Widget.Window({
    name: WINDOW_NAME,
    popup: true,
    visible: false,
    //focusable: true,
    keymode: "exclusive",
    anchor: ['top', 'left'],
    child: Applauncher({
        width: 360,
        height: 500,
        spacing: 12,
    }),
});

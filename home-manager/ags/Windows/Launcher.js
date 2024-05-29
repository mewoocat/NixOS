import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import { user, uptime } from '../variables.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { isLauncherOpen } from '../variables.js';
import { CloseOnClickAway } from '../Common.js';

const WINDOW_NAME = 'applauncher';

/** @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app */
const AppItem = app => Widget.Button({
    class_name: "app-button",
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
                css: `
                    margin: 0.4rem;
                `,
                class_name: 'title',
                label: app.name,
                xalign: 0,
                vpack: 'center',
                truncate: 'end',
            }),
        ],
    }),
});

// Power buttons
const powerButtons = Widget.Box({
    hpack: "end",
    children: [
        Widget.Button({
            class_name: "power-button",
            vpack: "center",
            //child: Widget.Label({label: "", justification: "center"}),
            child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
            on_primary_click: () => execAsync('shutdown now'),
        }),
        Widget.Button({
            class_name: "power-button",
            vpack: "center",
            //child: Widget.Label({label: ""}),
            child: Widget.Icon({icon: "system-hibernate-symbolic", size: 20}),
            on_primary_click: () => execAsync('systemctl hibernate'),
        }),
        Widget.Button({
            class_name: "power-button",
            vpack: "center",
            //child: Widget.Label({label: "⏾"}),
            child: Widget.Icon({icon: "system-suspend-symbolic", size: 20}),
            on_primary_click: () => execAsync('systemctl suspend'),
        }),
        Widget.Button({
            class_name: "power-button",
            vpack: "center",
            //child: Widget.Label({label: ""}),
            child: Widget.Icon({icon: "system-restart-symbolic", size: 20}),
            on_primary_click: () => execAsync('systemctl reboot'),
        }),
    ]
})


const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))
var pfp = data.pfp

const UserInfo = Widget.Box({
    spacing: 4,
    children:[
        Widget.Box({
            css: `
                background-position: center;
                border-radius: 100%;
                min-width: 3rem;
                min-height: 3rem;
                background-size: cover;
                background-image: url("/home/eXia/Downloads/Capture.PNG");
            `,
        }),
        Widget.Label({
            label: user.bind(),
        }),
    ]
})


const Applauncher = ({ width = 440, height = 500, spacing = 0 }) => {
    // list of application buttons
    let applications = Applications.query('').map(AppItem);

    // container holding the buttons
    const list = Widget.Box({
        vertical: true,
        class_name: "app-list",
        children: applications,
        spacing: 4,
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
                applications[0].launch();
            }
        },

        // filter out the list
        on_change: ({ text }) => {
            var foundFirst = false
            applications.forEach(item => {
                item.visible = item.attribute.app.match(text);
                if (item.visible == true && foundFirst == false){
                    foundFirst = true
                }
            })
        },
    });


    // Highlight first item when entry is selected
    // 'notify::"property"' is a event that gobjects send for each property
    // https://gjs-docs.gnome.org/gtk30~3.0/gtk.widget
    entry.on('notify::has-focus', ({ hasFocus }) => {
        list.toggleClassName("first-item", hasFocus)
    })

    return Widget.Box({
        css: 'padding: 1px;', //Gives box a defined size when revealer is showing anything
        child: Widget.Revealer({
            revealChild: false,
            transitionDuration: 150,
            transition: "slide_down",
            setup: self => {
                self.hook(App, (self, windowName, visible) => {
                    if (windowName === "applauncher"){
                        self.revealChild = visible
                    }
                }, 'window-toggled')
            },
            child: Widget.Box({
                class_name: "toggle-window",
                vertical: true,
                spacing: 8,
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
                    Widget.CenterBox({  
                        css: `
                            padding: 1.2rem;
                            border-radius: 1rem;
                        `,
                        class_name: "container",
                        startWidget: UserInfo,
                        centerWidget: Widget.Label(''),
                        endWidget: powerButtons,
                    })
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
            })
        })
    })
};

export const LauncherButton = () => Widget.Button({
    class_name: 'launcher normal-button',
    hpack: "start",
    on_primary_click: () => execAsync(`ags -t applauncher`), //toggleLauncherWindow(),
    child: Widget.Icon({
        icon: 'distributor-logo-nixos',
    }),
    /*
    child: Widget.Label({
        label: " "
    })
    */
});



// there needs to be only one instance
export const applauncher = Widget.Window({
    name: WINDOW_NAME,
    visible: false,
    layer: "overlay",
    keymode: "exclusive",
    anchor: ["top", "bottom", "left", "right"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top", "left"], // Debugging
    child: CloseOnClickAway(WINDOW_NAME, Applauncher({
        width: 340,
        height: 500,
        spacing: 12,
    }), "top-left"),
    //TODO: setup: self =>  self.keybind("Escape", () => App.closeWindow("window-name"))
});
applauncher.keybind("Escape", () => App.closeWindow(WINDOW_NAME))


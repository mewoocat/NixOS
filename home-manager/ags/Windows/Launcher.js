import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import { user, uptime } from '../variables.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { isLauncherOpen } from '../variables.js';

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

const UserInfo = Widget.Box({
    spacing: 4,
    children:[
        Widget.Label({
            label: user.bind(),
        }),
        Widget.Label({
            label: uptime.bind(),
        }),
        Widget.Icon({
            css: `
                border-radius: 1rem;
            `,
            //icon: "/home/eXia/ArchBackup/Pictures/zero.jpeg",
            size: 24,
        })
    ]
})


const Applauncher = ({ width = 500, height = 500, spacing = 12 }) => {
    // list of application buttons
    let applications = Applications.query('').map(AppItem);

    // container holding the buttons
    const list = Widget.Box({
        vertical: true,
        class_name: "app-list",
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
                    //print("found first: " + item)
                    //item.toggleClassName("first-item", true)
                    //item.class_name = "first-item"
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
        child:
            Widget.Revealer({
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
                child:

                    Widget.Box({
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
                            UserInfo,
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
    class_name: 'launcher',
    hpack: "start",
    on_primary_click: () => execAsync(`ags -t applauncher`), //toggleLauncherWindow(),
    child:
        Widget.Label({
            label: " "
        })
});



// there needs to be only one instance
export const applauncher = Widget.Window({
    name: WINDOW_NAME,
    visible: false,
    //focusable: true,
    popup: true,
    layer: "overlay",
    keymode: "exclusive",
    anchor: ['top', 'left'],
    child: Applauncher({
        width: 360,
        height: 500,
        spacing: 12,
    }),
    //TODO: setup: self =>  self.keybind("Escape", () => App.closeWindow("window-name"))
});

export function toggleLauncherWindow(){
    console.log(isLauncherOpen.value)
    if (isLauncherOpen.value == false){
        applauncher.keymode = "exclusive"
        isLauncherOpen.value = true
    }
    else{
        isLauncherOpen.value = false
        applauncher.keymode = "none"
    }
}

// Set function as global so that it can be ran via cli
globalThis['toggleLauncherWindow'] = toggleLauncherWindow

import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

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
                //class_name: 'app-button-label',
                label: app.name,
                xalign: 0,
                vpack: 'center',
                truncate: 'end',
            }),
        ],
    }),
});


// search entry
const entry = Widget.Entry({
    class_name: "app-entry",
    placeholder_text: "Search...",
    hexpand: true,
    css: `margin-bottom: 8px;`,

    // to launch the first item on Enter
    on_accept: ({ text }) => {
        applications = Applications.query(text || '');
        if (applications[0]) {
            App.toggleWindow(WINDOW_NAME); //Todo: get name from const
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


// list of application buttons
let applications = Applications.query('').map(AppItem);

// container holding the buttons
const list = Widget.Box({
    vertical: true,
    class_name: "app-list",
    children: applications,
    spacing: 4,
});

// wrap the list in a scrollable
const appScroller = Widget.Scrollable({
    css: `min-height: 400px;`,
    hscroll: 'never',
    child: list,
})

// repopulate the box, so the most frequent apps are on top of the list
function repopulate() {
    applications = Applications.query('').map(AppItem);
    list.children = applications;
}

// App searcher and list
export const AppLauncher = (WINDOW_NAME) => Widget.Box({
    //vexpand: true,
    vertical: true,
    children: [
        entry,
        appScroller, 
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

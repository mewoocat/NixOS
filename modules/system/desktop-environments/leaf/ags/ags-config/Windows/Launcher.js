import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import * as Common from '../Lib/Common.js';
import * as Applications from '../Modules/Applications.js';

const WINDOW_NAME = 'applauncher';

const Content = ({ width = 300, height = 400, spacing = 0 }) => Widget.Revealer({
    revealChild: true,
    /*
    transitionDuration: 150,
    transition: "slide_right",
    setup: self => {
        self.hook(App, (self, windowName, visible) => {
            if (windowName === WINDOW_NAME){
                self.revealChild = visible
            }
        }, 'window-toggled')
    },
    */
    child: Widget.Box({
        vertical: true,
        css: 'padding: 1px;', //Gives box a defined size when revealer is showing anything
        spacing: 8,
        class_name: "toggle-window",
        css: `
            min-width: ${width}px;
            min-height: ${height}px;
        `,
        children: [
            Applications.AppLauncher(WINDOW_NAME),
        ],
    })
})

export const LauncherButton = () => Widget.Button({
    class_name: 'launcher normal-button',
    hpack: "start",
    on_primary_click: () => Utils.execAsync(`ags -t applauncher`), //toggleLauncherWindow(),
    child: Widget.Icon({
        size: 20,
        icon: 'distributor-logo-nixos',
    }),
});


export const Launcher = () => Widget.Window({
    name: WINDOW_NAME,
    css: `background-color: unset;`,
    visible: false,
    layer: "overlay",
    keymode: "exclusive",
    anchor: ["top", "bottom", "left", "right"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top", "left", "bottom"], // Debugging // idk why removing bottom from here causes the window to not open 
    child: Common.CloseOnClickAway(WINDOW_NAME, Content({
        spacing: 12,
    }), "top-left"),
    setup: self =>  self.keybind("Escape", () => App.closeWindow(WINDOW_NAME))
});

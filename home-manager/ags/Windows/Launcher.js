import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { CloseOnClickAway } from '../Common.js';
import { powerButtons } from '../Modules/Power.js';
import { UserInfo } from '../Modules/User.js';
import { AppLauncher } from '../Modules/Applications.js';

const WINDOW_NAME = 'applauncher';

const Content = ({ width = 300, height = 400, spacing = 0 }) => Widget.Revealer({
    revealChild: false,
    transitionDuration: 150,
    transition: "slide_down",
    setup: self => {
        self.hook(App, (self, windowName, visible) => {
            if (windowName === WINDOW_NAME){
                self.revealChild = visible
            }
        }, 'window-toggled')
    },
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
            AppLauncher(WINDOW_NAME),
            // User and power menu
            Widget.CenterBox({  
                css: `
                    padding: 0.8rem;
                    border-radius: 1rem;
                `,
                class_name: "container",
                startWidget: UserInfo,
                centerWidget: Widget.Label(''),
                endWidget: powerButtons,
            })
        ],
    })
})

export const LauncherButton = () => Widget.Button({
    class_name: 'launcher normal-button',
    hpack: "start",
    on_primary_click: () => execAsync(`ags -t applauncher`), //toggleLauncherWindow(),
    child: Widget.Icon({
        icon: 'distributor-logo-nixos',
    }),
});


export const Launcher = Widget.Window({
    name: WINDOW_NAME,
    visible: false,
    layer: "overlay",
    keymode: "exclusive",
    anchor: ["top", "bottom", "left", "right"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top", "left", "bottom"], // Debugging // idk why removing bottom from here causes the window to not open 
    child: CloseOnClickAway(WINDOW_NAME, Content({
        spacing: 12,
    }), "top-left"),
    setup: self =>  self.keybind("Escape", () => App.closeWindow(WINDOW_NAME))
});

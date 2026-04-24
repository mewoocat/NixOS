import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import * as WS from '../Modules/Workspaces.js';
import * as Common from '../Lib/Common.js';

const WINDOW_NAME = "Workspaces"

const Container = () => {
    return Widget.Box({
        class_name: "toggle-window",
        children: [
            WS.WorkspaceGrid()
        ]
    })
}

export const Workspaces = (monitor = 0) => Widget.Window({
    name: WINDOW_NAME,
    monitor,
    visible: true,
    css: `background-color: unset;`,
    //anchor: ['left', 'top'], # debug
    anchor: ["top", "bottom", "left", "right"], // Anchoring on all corners is used to stretch the window across the whole screen 
    exclusivity: 'exclusive',
    child: Common.CloseOnClickAway(WINDOW_NAME, Container(), "top-left"),
    setup: (self) => {
        self.keybind("Escape", () => {
            App.closeWindow(WINDOW_NAME)
        })
    }
});

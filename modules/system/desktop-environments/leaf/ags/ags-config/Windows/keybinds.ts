import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import * as Common from '../Lib/Common.js';
import * as Global from '../Global.js'

type keybind = {
    keyCombo: string,
    description: string,
    command: string
}

const WINDOW_NAME = "Keybinds"

const KeybindGrid = Global.Grid()
let keybinds: keybind[] = [];

const readInKeybinds = (): void => {

}

const generateKeybindWidgets = (): void => {
    for (const keybind of keybinds) {

    }
}

readInKeybinds()
generateKeybindWidgets()

const Container = () => Widget.Box({
    vertical: true,
    children: KeybindGrid(),
})

export const Keybinds = (monitor = 0) => Widget.Window({
    name: WINDOW_NAME,
    //css: `background-color: unset;`,
    visible: false,
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top"], // Debug
    exclusivity: 'normal',
    child: Common.CloseOnClickAway(WINDOW_NAME, Container(), "center"),
});

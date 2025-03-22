import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import App from 'resource:///com/github/Aylur/ags/app.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import GLib from 'gi://GLib'
import * as Common from '../Lib/Common.js';
import * as Global from '../Global.js'
import * as Log from '../Lib/Log.js'

type keybind = {
    keyCombo: string,
    description: string,
    category: string
}

const sampleKeybind: keybind = {
    keyCombo: "Super + x",
    description: "Open app launcher",
    category: "General"
}

const WINDOW_NAME = "Keybinds"

const KeybindGrid = Global.Grid()
let keybinds: keybind[] = [];
/*
keybinds.push(sampleKeybind)
keybinds.push(sampleKeybind)
keybinds.push(sampleKeybind)
*/

const readInKeybinds = (): void => {
    const hyprlandConfigPath = `${GLib.get_home_dir()}/.config/hypr/hyprland.conf`
    const fileContents = Utils.readFile(hyprlandConfigPath)
    const lines: string[] = fileContents.split('\n')
    // Matches string which doesn't start with a '#' starts with a 'bind =' with amount 
    // of spaces between and around the words
    const keybindPattern = new RegExp("^(?!#) *bind *= *")
    const keyComboPattern = new RegExp("(?<= *bind *= *).*")
    for (const line of lines) {
        if (line.match(keybindPattern)){
            let keyCombo: string = "N/A"
            let description: string = "N/A"
            let category: string = "N/A"
            Log.Info(line)
            const keyComboMatch = keyComboPattern.exec(line)?.toString().split(',')
            if (keyComboMatch !== undefined) {
                Log.Info(keyComboMatch[0] + ' ' + keyComboMatch[1])
                keyCombo = keyComboMatch[0] + ' ' + keyComboMatch[1]
            }
            const descriptionAndCategoryPattern = new RegExp("(?<=#).*")
            const descriptionAndCategoryMatch = descriptionAndCategoryPattern.exec(line)?.toString().split('#')
            if (descriptionAndCategoryMatch !== undefined) {
                Log.Info(descriptionAndCategoryMatch)
                description = descriptionAndCategoryMatch[0]
                category = descriptionAndCategoryMatch[1]
            }

            const keybind = {
                keyCombo: keyCombo,
                description: description,
                category: category
            }

            keybinds.push(keybind)
        }
    }
}
readInKeybinds()

const createKeybindWidget = (keybind: keybind): void => {
    return Widget.Box({
        spacing: 4,
        children: [
            Widget.Label(keybind.keyCombo),
            Widget.Label(keybind.description),
            Widget.Label(keybind.category),
        ]
    })
}

const generateKeybindWidgets = (): void => {
    let row = 1
    let column = 1
    for (const keybind of keybinds) {
        const widget = createKeybindWidget(keybind)
        KeybindGrid.attach(widget, column, row, 1, 1)
        column++
        if (column > 4) {
            row++
            column = 1 
        }
    }
}

readInKeybinds()
generateKeybindWidgets()

const Container = () => Widget.Box({
    class_name: "toggle-window",
    vertical: true,
    children: [
        Widget.Label({
            label: "Keybinds"
        }),
        Widget.Scrollable({
            vexpand: true,
            hscroll: "never",
            child: KeybindGrid,
        })
    ],
})

export const Window = (monitor = 0) => Widget.Window({
    name: WINDOW_NAME,
    css: `background-color: unset;`,
    visible: false,
    anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
    //anchor: ["top"], // Debug
    exclusivity: 'normal',
    layer: "overlay",
    keymode: "exclusive",
    child: Common.CloseOnClickAway(WINDOW_NAME, Container(), "center"),
    setup: self => {
        self.keybind("Escape", () => {
            App.closeWindow(WINDOW_NAME)
        })
    }
});

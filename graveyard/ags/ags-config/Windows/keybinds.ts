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

const WINDOW_NAME = "Keybinds"

const keybindFlowBox = Widget.FlowBox({
    //max_children_per_line: 3,
    row_spacing: 8,
    column_spacing: 8,
})

let keybinds = {};

const readInKeybinds = (): void => {
    const hyprlandConfigPath = `${GLib.get_home_dir()}/.config/hypr/hyprland.conf`
    const fileContents = Utils.readFile(hyprlandConfigPath)
    const lines: string[] = fileContents.split('\n')
    // Matches string which doesn't start with a '#' starts with a 'bind =' with amount 
    // of spaces between and around the words
    const keybindPattern = new RegExp("^(?!#) *bind *= *")
    const keyComboPattern = new RegExp("(?<= *bind *= *).*")
    const mainModPattern = /^\s*\$mainMod\s*=\s*(.*)/
    let mainMod = "N/A"
    for (const line of lines) {
        // Check for mainMod value
        const mainModMatch = mainModPattern.exec(line)
        if (mainModMatch !== null) {
            mainMod = mainModMatch[1] // Access first capturing group
            //Log.Info(`Found mainMod of ${mainMod}`)
        }

        if (line.match(keybindPattern)){
            let keyCombo: string = "N/A"
            let description: string = "N/A"
            let category: string = "N/A"
            //Log.Info(line)
            const keyComboMatch = keyComboPattern.exec(line)?.toString().split(',')
            if (keyComboMatch !== undefined) {
                //Log.Info(keyComboMatch[0] + ' ' + keyComboMatch[1])
                keyCombo = keyComboMatch[0] + ' + ' + keyComboMatch[1]
                keyCombo = keyCombo.replace("$mainMod", mainMod)
            }
            const descriptionAndCategoryPattern = new RegExp("(?<=#).*")
            const descriptionAndCategoryMatch = descriptionAndCategoryPattern.exec(line)?.toString().split('#')
            if (descriptionAndCategoryMatch !== undefined) {
                //Log.Info(descriptionAndCategoryMatch)
                category = descriptionAndCategoryMatch[0]
                description = descriptionAndCategoryMatch[1]
            }

            const keybind = {
                keyCombo: keyCombo,
                description: description,
                category: category
            }

            if (keybinds[category] === undefined) {
                keybinds[category] = []
            }
            keybinds[category].push(keybind)
        }
    }
}
readInKeybinds()

const createKeybindWidget = (keybind: keybind): void => {
    return Widget.Box({
        css: `
            padding: 0.2rem;
        `,
        spacing: 16,
        children: [
            Widget.Label({
                hexpand: true,
                hpack: "start",
                label: keybind.description,
            }),
            Widget.Label(keybind.keyCombo),
        ]
    })
}

//Log.Info(JSON.stringify(keybinds, null, 4))

const generateKeybindWidgets = (): void => {

    const categories = Object.keys(keybinds)
    for (const category of categories) {
        let categoryChildren: Widget[] = []

        const categoryLabelWidget = Widget.Box({
            vertical: true,
            children: [
                Widget.Label({
                    class_name: "large-text",
                    hpack: "start",
                    label: category,
                }),
                Widget.Separator({class_name: "horizontal-separator"}),
            ]
        })
        categoryChildren.push(categoryLabelWidget)

        for (const keybind of keybinds[category]) {
            const widget = createKeybindWidget(keybind)
            categoryChildren.push(widget)
        }
        const categoryBox = Widget.Box({
            vertical: true,
            children: categoryChildren,
        })
        keybindFlowBox.add(categoryBox)
    }
}

generateKeybindWidgets()

const Container = () => Widget.Box({
    class_name: "toggle-window",
    vertical: true,
    /*
    css: `
        min-width: 1000px;
        min-height: 500px;
    `,
    */
    children: [
        Widget.Label({
            label: "Keybinds"
        }),
        Widget.Scrollable({
            vexpand: true,
            hscroll: "never",
            child: keybindFlowBox,
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

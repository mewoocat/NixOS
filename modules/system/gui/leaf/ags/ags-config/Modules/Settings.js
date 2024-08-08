
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { locationSearch } from '../Modules/Weather.js'
import icons from '../icons.js';
import GLib from 'gi://GLib';
import Gio from 'gi://Gio';
const { Gtk } = imports.gi;
import { exec, writeFile, readFile } from 'resource:///com/github/Aylur/ags/utils.js'

import { Options, data, CreateOptionWidget, ApplySettings } from '../Options/options.js'



export const generalFlowBox = () => Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
    setup: (self) => {
        // Load in options as widgets
        for (let key in Options){
            let option = Options[key]
            let widget = CreateOptionWidget(option)
            let label = Widget.Label({
                label: option.name,
                hpack: "start",
            })

            // Add ref of created widget to option object
            Options[key].widget = widget 

            // Add widget to box
            self.add(Widget.CenterBox({
                class_name: "option-container",
                startWidget: label,
                endWidget: widget,
            }))

        }
    },
})
//generalFlowBox.add(locationSearch)


export const ApplyButton = () => Widget.Button({
    class_name: "normal-button bg-button",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => ApplySettings(),
    child: Widget.Label("Apply"),
})

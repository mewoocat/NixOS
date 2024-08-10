
import Widget   from 'resource:///com/github/Aylur/ags/widget.js';
import App      from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import icons from '../icons.js';
import { locationSearch } from '../Modules/Weather.js'
import { exec, writeFile, readFile } from 'resource:///com/github/Aylur/ags/utils.js'
import { Options, data, LoadOptionWidgets, ApplySettings } from '../Options/options.js'


export const generalSettings = Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
})
//generalFlowBox.add(locationSearch)


export const ApplyButton = () => Widget.Button({
    class_name: "normal-button bg-button",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => ApplySettings(),
    child: Widget.Label("Apply"),
})

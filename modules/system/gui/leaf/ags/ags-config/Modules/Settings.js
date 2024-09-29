
import Widget   from 'resource:///com/github/Aylur/ags/widget.js';
import App      from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import icons from '../icons.js';
import { exec, writeFile, readFile } from 'resource:///com/github/Aylur/ags/utils.js'
import { Options, data, LoadOptionWidgets, ApplySettings, RevertSettings, settingsChanged } from '../Options/options.js'


export const generalSettings = Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
})

//import { locationSearch } from '../Modules/Weather.js'
//generalFlowBox.add(locationSearch)

export const displaySettings = Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
})


export const ApplyButton = () => Widget.Button({
    visible: settingsChanged.bind(), 
    class_name: "normal-button bg-button",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => ApplySettings(),
    child: Widget.Label("Apply"),
})

export const ChangedOptionsIndicator = () => Widget.Button({
    visible: settingsChanged.bind(), 
    class_name: "normal-button bg-button-alert",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => RevertSettings(),
    child: Widget.Label("Revert"),
})

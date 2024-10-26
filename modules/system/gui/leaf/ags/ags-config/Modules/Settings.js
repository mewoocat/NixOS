import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import App from 'resource:///com/github/Aylur/ags/app.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js'

import icons from '../icons.js';
import * as Options from '../Options/options.js'


export const generalSettings = Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
})

export const displaySettings = Widget.FlowBox({
    vpack: "start",
    max_children_per_line: 1,
})

export const ApplyButton = () => Widget.Button({
    visible: Options.settingsChanged.bind(), 
    class_name: "normal-button bg-button",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => Options.ApplySettings(),
    child: Widget.Label("Apply"),
})

export const ChangedOptionsIndicator = () => Widget.Button({
    visible: Options.settingsChanged.bind(), 
    class_name: "normal-button bg-button-alert",
    vpack: "center",
    hpack: "end",
    on_primary_click: () => Options.RevertSettings(),
    child: Widget.Label("Revert"),
})

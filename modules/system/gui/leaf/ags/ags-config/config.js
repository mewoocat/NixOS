import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
// Add icons in assets to icon set
//Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
// Need to do this before importing anything else since importing could try to eval an custom icon which has not been added yet
// Doesn't seem to fix the issue tho
App.addIcons(`${App.configDir}/assets`)

print("importing options")
import {data, GetOptions, Options, LoadOptionWidgets} from './Options/options.js';
// Loads json config and options
GetOptions()

import { generalSettings, displaySettings } from './Modules/Settings.js';
// Load the user options as widgets into the generalSettings FlowBox
LoadOptionWidgets(Options.user.general, generalSettings)
LoadOptionWidgets(Options.user.display, displaySettings)

import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './Common.js';
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/NotificationPopups.js';
import { Dock } from './Windows/Dock.js';
import { Launcher } from './Windows/Launcher.js';
import { Bar } from './Windows/Bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
import { monitors } from './Monitors.js'

print("importing settings")
import { Settings } from './Windows/Settings.js';
import { GenerateCSS, css } from './Style/style.js'

// Compile and apply scss as css
GenerateCSS()

// Monitor for color changes and reapply
monitorFile(`${App.configDir}/Style/_colors.scss`, GenerateCSS);

function InitilizeWindows(){

    const userDefaultMonitor = Options.user.display.default_monitor.value
    let defaultMonitorID = 0

    // Find the id num associated with the monitor identifier
    if (monitors[userDefaultMonitor] != undefined){
        defaultMonitorID = monitors[userDefaultMonitor]
    }

    print("INFO: defaultMonitorID: " + defaultMonitorID)

    const windows = [
        Launcher(), 
        // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
        // ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
        //...forMonitors(Bar), 
        Bar(defaultMonitorID),
        ControlPanel(),
        ActivityCenter(),
        NotificationPopup(), 
        Settings(),
        //Dock()
    ]
    return windows
}

App.config({
    style: css, 
    closeWindowDelay: {
        "ControlPanel":     150, // milliseconds
        "applauncher":      150, // milliseconds
        "ActivityCenter":   150, // milliseconds
    },
    windows: InitilizeWindows(),
});


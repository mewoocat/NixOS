import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
// Add icons in assets to icon set
//Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
// Need to do this before importing anything else since importing could try to eval an custom icon which has not been added yet
// Doesn't seem to fix the issue tho
App.addIcons(`${App.configDir}/assets`)

print("importing options")
import {data, GetOptions, Options, LoadOptionWidgets} from './Options/options.js';
// Loads json config and options
GetOptions()

import * as Common from './Common.js';
import * as Settings from './Modules/Settings.js';
// Load the user options as widgets into the generalSettings FlowBox
LoadOptionWidgets(Options.user.general, Settings.generalSettings)
LoadOptionWidgets(Options.user.display, Settings.displaySettings)


// Import windows
import * as ActivityCenter from './Windows/ActivityCenter.js';
import * as NotificationPopup from './Windows/NotificationPopups.js';
import * as Dock from './Windows/Dock.js';
import * as Launcher from './Windows/Launcher.js';
import * as Bar from './Windows/Bar.js';
import * as ControlPanel from './Windows/ControlPanel.js';
import * as Monitors from './Monitors.js'

print("importing settings")
import * as SettingsWin from './Windows/Settings.js';
import * as Style from './Style/style.js'

// Compile and apply scss as css
Style.GenerateCSS()

// Monitor for color changes and reapply
Utils.monitorFile(`${App.configDir}/Style/_colors.scss`, Style.GenerateCSS);

function InitilizeWindows(){

    const userDefaultMonitor = Options.user.display.default_monitor.value
    let defaultMonitorID = 0

    // Find the id num associated with the monitor identifier
    if (Monitors.monitors[userDefaultMonitor] != undefined){
        defaultMonitorID = Monitors.monitors[userDefaultMonitor]
    }

    print("INFO: defaultMonitorID: " + defaultMonitorID)

    const windows = [
        // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
        // ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
        //...Common.forMonitors(Bar), 
        Bar.Bar(defaultMonitorID),
        Launcher.Launcher(), 
        ControlPanel.ControlPanel(),
        ActivityCenter.ActivityCenter(),
        NotificationPopup.NotificationPopup(), 
        SettingsWin.SettingsWin(),
        //Dock.Dock()
    ]
    return windows
}

App.config({
    style: Style.css, 
    closeWindowDelay: {
        "ControlPanel":     150, // milliseconds
        "applauncher":      150, // milliseconds
        "ActivityCenter":   150, // milliseconds
    },
    windows: InitilizeWindows(),
});

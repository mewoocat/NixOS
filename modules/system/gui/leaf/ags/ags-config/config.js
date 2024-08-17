import App from 'resource:///com/github/Aylur/ags/app.js';
// Add icons in assets to icon set
//Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
// Need to do this before importing anything else since importing could try to eval an custom icon which has not been added yet
// Doesn't seem to fix the issue tho
App.addIcons(`${App.configDir}/assets`)

print("importing options")
import { GetOptions, Options, LoadOptionWidgets} from './Options/options.js';
// Loads json config and options
GetOptions()

import { generalSettings } from './Modules/Settings.js';
// Load the user options as widgets into the generalSettings FlowBox
LoadOptionWidgets(Options.user, generalSettings)


import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './Common.js';
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/NotificationPopups.js';
import { Dock } from './Windows/Dock.js';
import { Launcher } from './Windows/Launcher.js';
import { Bar } from './Windows/Bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
print("importing settings")
import { Settings } from './Windows/Settings.js';

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

// GDK Display
import Gdk from 'gi://Gdk'
const display = new Gdk.Display()

// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
const css = `${App.configDir}/Style/style.css`

// Generate css
exec(`sassc ${scss} ${css}`)

// Monitor for style changes and reapply
monitorFile(
    `${App.configDir}/Style/_colors.scss`,
    function() {
        exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/Style/style.css`);
    },
);

function InitilizeWindows(){

    const userDefaultMonitor = Options.user.default_monitor.value
    let defaultMonitor = 0

    // Check if monitor exists
    Hyprland.monitors.forEach(m => {
        if (m.id == userDefaultMonitor){
            defaultMonitor = userDefaultMonitor
        }
    })

    print("User default monitor:\n" + JSON.stringify(userDefaultMonitor, null, 4))

    const windows = [
        Launcher(), 
        // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
        // ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
        //...forMonitors(Bar), 
        Bar(defaultMonitor),
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


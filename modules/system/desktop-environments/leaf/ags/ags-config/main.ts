import App from 'resource:///com/github/Aylur/ags/app.js';
import Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Gtk from 'gi://Gtk'
import GLib from 'gi://GLib'

import * as Log from './Lib/Log.js'
import './Controller.ts'

// Add icons in assets to icon set
//Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);
// Need to do this before importing anything else since importing could try to eval an custom icon which has not been added yet
// Doesn't seem to fix the issue tho
App.addIcons(`${App.configDir}/assets`)

Log.Info("Importing options")
//import {data, GetOptions, Options, LoadOptionWidgets} from './Options/options.js';
import * as Options from './Options/options.js'
// Loads json config and options
Options.GetOptions()

import * as Settings from './Modules/Settings.js';
// Load the user options as widgets into the generalSettings FlowBox
Options.LoadOptionWidgets(Options.Options.user.general, Settings.generalSettings)
Options.LoadOptionWidgets(Options.Options.user.display, Settings.displaySettings)


// Configure animations
Log.Info(`Ags animations?: ${Options.Options.user.general.ags_animations.value}`)
// I think this only applys the option to the default window
Gtk.Settings.get_default().gtk_enable_animations = Options.Options.user.general.ags_animations.value


// Import windows
import * as ActivityCenter from './Windows/ActivityCenter.js';
import * as NotificationPopup from './Windows/NotificationPopups.js';
import * as Dock from './Windows/Dock.js';
import * as Launcher from './Windows/Launcher.js';
import * as Bar from './Windows/Bar.js';
import * as ControlPanel from './Windows/ControlPanel.js';
import * as Monitors from './Monitors.js'
import * as SettingsWin from './Windows/Settings.js';
import * as Keybinds from './Windows/keybinds.ts';
import * as Style from './Style/style.js'

// Compile and apply scss as css
Style.GenerateCSS()

// Monitor for color changes and reapply
Utils.monitorFile(`${GLib.get_home_dir()}/.config/leaf-de/theme/_ags-colors.scss`, () => {
    Log.Info("Reloading css")
    Style.GenerateCSS()
});

function InitilizeWindows(){

    const userDefaultMonitor = Options.Options.user.display.default_monitor.value
    let defaultMonitorID = 0

    // Find the id num associated with the monitor identifier
    if (Monitors.monitors[userDefaultMonitor] != undefined){
        defaultMonitorID = Monitors.monitors[userDefaultMonitor]
    }

    Log.Info("defaultMonitorID: " + defaultMonitorID)

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
        Keybinds.Window(),
        Dock.Dock()

    ]
    return windows
}

App.config({
    style: Style.css, 
    /*
    closeWindowDelay: {
        // For delaying the closing of a window util the ags animation finished
        "ControlPanel":     400, // milliseconds
        "applauncher":      400, // milliseconds
        "ActivityCenter":   400, // milliseconds
    },
    */
    windows: InitilizeWindows(),
});



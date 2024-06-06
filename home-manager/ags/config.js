import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './utils.js';
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/Notification.js';
import { Dock } from './Windows/Dock.js';
import { Lockscreen } from './Windows/Lockscreen.js';
import { Launcher } from './Windows/Launcher.js';
import { Bar } from './Windows/Bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';

// GDK Display
import Gdk from 'gi://Gdk'
const display = new Gdk.Display()
//print("display" + display)

// Add icons in assets to icon set
import Gtk from 'gi://Gtk';
Gtk.IconTheme.get_default().append_search_path(`${App.configDir}/assets`);


// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
const css = `${App.configDir}/Style/style.css`

// Generate css
exec(`sassc ${scss} ${css}`)

monitorFile(
    `${App.configDir}/Style/_colors.scss`,
    function() {
        exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/Style/style.css`);
    },
);

App.config({
    style: css, 
    closeWindowDelay: {
        "ControlPanel":     150, // milliseconds
        "applauncher":      150, // milliseconds
        "ActivityCenter":   150, // milliseconds
    },
    // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
    // ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
    windows: [
        Launcher, 
        //...forMonitors(Bar), 
        Bar(),
        Lockscreen(), 
        ControlPanel,
        ActivityCenter(),
        NotificationPopup, 
        Dock()
    ],
});


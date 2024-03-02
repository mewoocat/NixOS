import { applauncher } from './Windows/Launcher.js';
import { bar } from './Windows/bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/NotificationPopup.js';
import { Dock } from './Windows/Dock.js';
import { Lockscreen } from './Windows/Lockscreen.js';


// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
const css = `${App.configDir}/Style/style.css`

exec(`sassc ${scss} ${css}`)

import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

// Does this just watch for css changes to then reload them?
monitorFile(
    `${App.configDir}/Style/_colors.scss`,
    function() {
        exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/Style/style.css`);
    },
);

export default {
    style: css, 

    //close delay
    closeWindowDelay: {
        applauncher: 350,
    },
    // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
    // ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
    windows: [applauncher, ...forMonitors(bar), Lockscreen(), ControlPanel, ActivityCenter(), NotificationPopup, /*Dock()*/],
};

import { applauncher } from './Windows/applauncher.js';
import { bar } from './Windows/bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/NotificationPopup.js';
import { Dock } from './Windows/Dock.js';


// main scss file
const scss = `${App.configDir}/style.scss`

// target css file
const css = `${App.configDir}/style.css`

exec(`sassc ${scss} ${css}`)

import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

// Does this just watch for css changes to then reload them?
monitorFile(
    `${App.configDir}/_colors.scss`,
    function() {
        exec(`sassc ${scss} ${css}`)
        App.resetCss();
        App.applyCss(`${App.configDir}/style.css`);
    },
);

// ... here returns the array output of forMonitors as a individual elements so they are not nested in the parrent array
export default {
    style: css, 
    //style: `./style.css`,
    // What does ... do? Spread syntax allows you to deconstruct an array or object into separate variables.
    windows: [applauncher, ...forMonitors(bar), ControlPanel, ActivityCenter(), NotificationPopup, Dock()],
};

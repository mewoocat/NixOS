import { applauncher } from './Windows/applauncher.js';
import { bar } from './Windows/bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'
import { forMonitors } from './utils.js';
import { ActivityCenter } from './Windows/ActivityCenter.js';
import { NotificationPopup } from './Windows/NotificationPopup.js';

import { execAsync, timeout } from 'resource:///com/github/Aylur/ags/utils.js';
timeout(100, () => execAsync([
    'notify-send',
    'Notification Popup Example',
    'Lorem ipsum dolor sit amet, qui minim labore adipisicing ' +
    'minim sint cillum sint consectetur cupidatat.',
    '-A', 'Cool!',
    '-i', 'info-symbolic',
]));


// main scss file
const scss = `${App.configDir}/style.scss`

// target css file
const css = `${App.configDir}/style.css`

exec(`sassc ${scss} ${css}`)

export default {
    style: css, 
    //style: `./style.css`,
    windows: [applauncher, forMonitors(bar), ControlPanel(), ActivityCenter(), NotificationPopup,],
};

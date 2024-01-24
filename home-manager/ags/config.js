import { applauncher } from './Windows/applauncher.js';
import { bar } from './Windows/bar.js';
import { ControlPanel } from './Windows/ControlPanel.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'


// main scss file
const scss = `${App.configDir}/style.scss`

// target css file
const css = `${App.configDir}/style.css`

exec(`sassc ${scss} ${css}`)

export default {
    style: css, 
    //style: `./style.css`,
    windows: [applauncher, bar(), ControlPanel(),],
};

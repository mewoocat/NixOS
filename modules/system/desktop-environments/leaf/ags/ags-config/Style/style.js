import App from 'resource:///com/github/Aylur/ags/app.js';
import GLib from 'gi://GLib'
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
export const css = `${GLib.get_home_dir()}/.config/leaf-de/ags.css`

// Generate & apply css
export function GenerateCSS(){
    exec(`sassc ${scss} ${css}`)
    App.resetCss();
    App.applyCss(`${css}`);
}

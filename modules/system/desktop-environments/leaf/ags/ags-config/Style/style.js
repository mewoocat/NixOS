import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js'

// main scss file
const scss = `${App.configDir}/Style/style.scss`

// target css file
export const css = `${App.configDir}/Style/style.css`

// Generate & apply css
export function GenerateCSS(){
    exec(`sassc ${scss} ${css}`)
    App.resetCss();
    App.applyCss(`${css}`);
}

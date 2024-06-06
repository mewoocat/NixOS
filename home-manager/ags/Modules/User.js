import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { user } from '../variables.js';

const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))
var pfp = data.pfp

export const UserInfo = Widget.Box({
    spacing: 4,
    children:[
        Widget.Box({
            css: `
                background-position: center;
                border-radius: 100%;
                min-width: 3rem;
                min-height: 3rem;
                background-size: cover;
                background-image: url("${App.configDir}/../../.cache/ags/pfp");
            `,
        }),
        Widget.Label({
            label: user.bind(),
        }),
    ]
})
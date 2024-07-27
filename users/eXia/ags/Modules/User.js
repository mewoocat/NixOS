import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

export const user = Variable("...", {
    poll: [60000, 'whoami', out => out]
});

const data = JSON.parse(Utils.readFile(`${App.configDir}/../../.cache/ags/UserSettings.json`))
var pfp = data.pfp

export const UserIcon = (size = 2) => Widget.Box({
    hexpand: false,
    vexpand: false,
    vpack: "center",
    hpack: "center",
    css: `
        margin-left: 0.4rem;
        background-position: center;
        border-radius: 100%;
        min-width: ${size}rem;
        min-height: ${size}rem;
        background-size: cover;
        background-image: url("${App.configDir}/../../.cache/ags/pfp");
    `,
})


export const UserName = (size = 1) => Widget.Label({
    css: `
        margin-left: 0.4rem;
        font-weight: bold;
        font-size: ${size}rem;
    `,
    label: user.bind(),
})

export const UserInfo = Widget.Box({
    spacing: 4,
    children:[
        UserIcon(2),
        UserName(),
    ]
})

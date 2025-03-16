import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'
import GdkPixbuf from 'gi://GdkPixbuf'

import * as Global from '../Global.js'
import * as Log from '../Lib/Log.js'

export const user = Variable("...", {
    poll: [60000, 'whoami', out => out]
});

const defaultPFPPath = `${Global.leafDir}/assets/default-pfp.png`
const pfpPath = `${Global.leafConfigDir}/pfp`

export const UserIcon = (size = 2) => {
    const createUserIconWidget = (size, pfpPath) => Widget.Box({
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
            background-image: url("${pfpPath}");
        `,
    })

    let widget
    // Try to load user provided pfp
    try {
        GdkPixbuf.Pixbuf.new_from_file(pfpPath) // Just attempt to load the file to check if it's valid
        widget = createUserIconWidget(size, pfpPath)
    // If error occurs, use default
    } catch (error) {
        Log.Error(`Couldn't load user profile picture: ${error}`)    
        Log.Info(`Falling back to default profile picture at ${defaultPFPPath}`)
        widget = createUserIconWidget(size, defaultPFPPath)
    }

    return widget
}

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

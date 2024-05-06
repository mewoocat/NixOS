import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

function ClickSpace(window){
    return Widget.EventBox({
        vexpand: true,
        hexpand: true,
        on_primary_click: () => App.closeWindow(window),
    })
}

// This only works with top right windows right now
// More info https://github.com/Aylur/dotfiles/blob/main/ags/widget/PopupWindow.ts
// Valid layouts: top-right, top-left, top-center
export function CloseOnClickAway(windowName, content, layout) {
    if (layout === "top-right") {
        return Widget.Box({
            children: [
                ClickSpace(windowName),
                Widget.Box({
                    vertical: true,
                    hexpand: false,
                    children: [
                        content,
                        ClickSpace(windowName)
                    ]
                }),
            ],
        })
    }
    else if (layout === "top-center") {
        return Widget.Box({
            children: [
                ClickSpace(windowName),
                Widget.Box({
                    vertical: true,
                    hexpand: false,
                    children: [
                        content,
                        ClickSpace(windowName),
                    ]
                }),
                ClickSpace(windowName),
            ],
        })
    }
    else if (layout === "top-left") {
        return Widget.Box({
            children: [
                Widget.Box({
                    vertical: true,
                    hexpand: false,
                    children: [
                        content,
                        ClickSpace(windowName)
                    ]
                }),
                ClickSpace(windowName),
            ],
        })
    }
    else {
        console.log("Error: Invalid layout for CloseOnClickAway()")
    }
}

export function SecToHourAndMin(seconds){
    var minutesRaw = Math.floor(seconds / 60) 
    var minutes = minutesRaw % 60
    var hours = Math.floor(minutesRaw / 60) 
    return `${hours} hours, and ${minutes} minutes`
}


import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

// This only works with top right windows right now
// More info https://github.com/Aylur/dotfiles/blob/main/ags/widget/PopupWindow.ts
export function CloseOnClickAway(windowName, content) {
    return Widget.Box({
        children: [
            Widget.EventBox({
                vexpand: true,
                hexpand: true,
                on_primary_click: () => App.closeWindow(windowName),
            }),
            Widget.Box({
                vertical: true,
                hexpand: false,
                children: [
                    content,
                    Widget.EventBox({
                        vexpand: true,
                        hexpand: true,
                        on_primary_click: () => App.closeWindow(windowName)
                    }),
                ]
            }),
        ],
    })
}
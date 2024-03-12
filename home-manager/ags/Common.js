import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

export function CloseOnClickAway(windowName, content) {
    return Widget.Box({
        children: [
            Widget.Box({
                    css: `
                        min-width: 2000px;
                    `,
                
                children: [
                    Widget.EventBox({
                        child: Widget.Label({label: "a"}),
                        expand: true,
                        on_primary_click: () => App.closeWindow(windowName),
                    }),
                ],
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Widget.EventBox({
                        expand: true,
                        on_primary_click: () => App.closeWindow(windowName),
                    }),
                    content,
                    Widget.EventBox({
                        expand: true,
                        on_primary_click: () => App.closeWindow(windowName)
                    }),
                ]
            }),
            Widget.EventBox({
                expand: true,
                on_primary_click: () => App.closeWindow(windowName)
            }),
        ],
    })
}
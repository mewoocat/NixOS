import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const PowerProfilesButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    child:
        Widget.Label({
            hexpand: true,
            label: ""
        })
})
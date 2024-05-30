import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const ThemeButton = (w, h) => Widget.Button({
    class_name: "control-panel-button",
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
        font-size: 22px;
    `,
    child:
        Widget.Icon({
            icon: "org.gnome.Settings-color-symbolic",
        })
})

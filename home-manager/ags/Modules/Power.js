import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
const powerProfiles = await Service.import('powerprofiles')

export const PowerProfilesButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_clicked: () => {
        switch (powerProfiles.active_profile) {
            case 'power-saver':
                powerProfiles.active_profile = 'performance';
                break;
            case 'performance':
                powerProfiles.active_profile = 'balanced';
                break;
            default:
                powerProfiles.active_profile = 'power-saver';
                break;
        };
    },
    child: Widget.Icon({
        size: 22,
        setup: self => {
            self.hook(powerProfiles, self => {
                if (powerProfiles.active_profile === "performance"){
                    self.icon = "power-profile-performance-symbolic-rtl" 
                    self.css = "color: red;"
                }
                else if (powerProfiles.active_profile === "balanced"){
                    self.icon = "power-profile-balanced-rtl-symbolic" 
                    self.css = "color: orange;"
                }
                else {
                    self.icon = "power-profile-power-saver-rtl-symbolic"
                    self.css = "color: green;"
                }
            })
        }
    })
})


// Power button revealer
const buttonRevealer = Widget.Revealer({
    transitionDuration: 300,
    transition: 'slide_left',
    revealChild: false,
    child: Widget.Box({
        children: [
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                //child: Widget.Label({label: "", justification: "center"}),
                child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
                on_primary_click: () => execAsync('shutdown now'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                //child: Widget.Label({label: ""}),
                child: Widget.Icon({icon: "system-hibernate-symbolic", size: 20}),
                on_primary_click: () => execAsync('systemctl hibernate'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                //child: Widget.Label({label: "⏾"}),
                child: Widget.Icon({icon: "system-suspend-symbolic", size: 20}),
                on_primary_click: () => execAsync('systemctl suspend'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                //child: Widget.Label({label: ""}),
                child: Widget.Icon({icon: "system-restart-symbolic", size: 20}),
                on_primary_click: () => execAsync('systemctl reboot'),
            }),
            // Spacer
            Widget.Label({label: "|"}),
        ]
    })
})

// Power buttons
export const powerButtons = Widget.Box({
    hpack: "end",
    children: [
        buttonRevealer,
        // Toggle button
        Widget.Button({
            vpack: "center",
            class_name: "power-button",
            child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
            on_primary_click: () => {
                buttonRevealer.revealChild = !buttonRevealer.revealChild 
            },
        }),
    ]
})



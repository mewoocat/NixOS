import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
const powerProfiles = await Service.import('powerprofiles')
import icons from '../icons.js'
import { CloseOnClickAway } from '../Common.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';


const WINDOW_NAME = "ConfirmationPopup"
const selectedAction = Variable(null)
const selectedConfirmationText = Variable("")


export const ConfirmationPopup = () =>{

    const content = Widget.Box({
        class_name: "container",
        css: `
            padding: 2rem;
        `,
        vertical: true,
        children: [
            Widget.Label({
                label: selectedConfirmationText.bind(),
            }),
            Widget.Box({
                children: [
                    Widget.Button({
                        on_primary_click: () => {
                            App.closeWindow(WINDOW_NAME)
                            selectedAction.value()
                        },
                        child: Widget.Label({
                            label: "Yes"
                        })
                    }),
                    Widget.Button({
                        on_primary_click: () => {
                            App.closeWindow(WINDOW_NAME)
                        },
                        child: Widget.Label({
                            label: "No"
                        })
                    }),
                ]
            })
        ]
    })

    return Widget.Window({
        name: WINDOW_NAME,
        css: `background-color: rgba(0,0,0, 0.64);`,
        visible: false,
        anchor: ["top", "bottom", "right", "left"], // Anchoring on all corners is used to stretch the window across the whole screen 
        layer: "overlay",
        keymode: "exclusive",
        exclusivity: 'normal',
        child: CloseOnClickAway(WINDOW_NAME, content, "center"),
        setup: self => {
            self.keybind("Escape", () => App.closeWindow(WINDOW_NAME))
        }
    });
}

const confirmationPopup = ConfirmationPopup()
App.addWindow(confirmationPopup)




// Creates a power button
function PowerButton(name, icon, action, confirmationText = "Are you sure?"){

    return Widget.MenuItem({
        onActivate: () => {
            selectedAction.value = action
            selectedConfirmationText.value = confirmationText
            App.openWindow(WINDOW_NAME)
            //confirmationPopup.visible = true
        },
        child: Widget.Box({
            children: [
                Widget.Icon({vpack: "center", icon: icon, size: 20}),
                Widget.Label({
                    hpack: "start",
                    label: " " + name
                }),
            ],
        }),
    })
}


// Popup power menu
const powerMenu = Widget.Menu({
    children: [
        // Fix these
        PowerButton("Shutdown", icons.shutdown, () => execAsync("shutdown now")),
        PowerButton("Hibernate", icons.hibernate, () => execAsync("systemctl hibernate")),
        PowerButton("Sleep", icons.suspend, () => execAsync("systemctl suspend")),
        PowerButton("Restart", icons.restart, () => execAsync("systemctl reboot")),
        PowerButton("Test", icons.settings, () => print("Testing...")),

    ],
})

export const togglePowerMenu = Widget.Button({
    vpack: "center",
    class_name: "normal-button",
    child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
    on_primary_click: (_, event) => {
        powerMenu.popup_at_pointer(event)
    },
})


export const PowerProfilesButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_clicked: () => {
        // Loop over all available power profiles
        for (let i = 0; i < powerProfiles.profiles.length; i++ ){
            // Find current profile
            if (powerProfiles.profiles[i].Profile === powerProfiles.active_profile){
                // Set current profile to next one in list
                // If not last element in list
                if(i < powerProfiles.profiles.length - 1){
                    powerProfiles.active_profile = powerProfiles.profiles[i + 1].Profile ;
                }
                // If last element in list
                else{
                    powerProfiles.active_profile = powerProfiles.profiles[0].Profile ;
                }
                // Stop searching
                break
            }
        }
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


/*
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
                child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
                on_primary_click: () => execAsync('shutdown now'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                child: Widget.Icon({icon: "system-hibernate-symbolic", size: 20}),
                on_primary_click: () => execAsync('systemctl hibernate'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
                child: Widget.Icon({icon: "system-suspend-symbolic", size: 20}),
                on_primary_click: () => execAsync('systemctl suspend'),
            }),
            Widget.Button({
                class_name: "power-button",
                vpack: "center",
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
            //class_name: "power-button",
            class_name: "normal-button",
            child: Widget.Icon({icon: "system-shutdown-symbolic", size: 20}),
            on_primary_click: () => {
                buttonRevealer.revealChild = !buttonRevealer.revealChild 
            },
        }),
    ]
})
*/

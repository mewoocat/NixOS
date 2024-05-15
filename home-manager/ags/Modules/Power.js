import Widget from 'resource:///com/github/Aylur/ags/widget.js';
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

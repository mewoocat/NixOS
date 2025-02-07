import Widget from 'resource:///com/github/Aylur/ags/widget.js'
import Utils from 'resource:///com/github/Aylur/ags/utils.js'
import Variable from 'resource:///com/github/Aylur/ags/variable.js'

const nightLightOn = Variable(isNightLightOn(), {}) 

function isNightLightOn() {
    // Check if wlsunset is running
    // Bash command outputs 0 if yes or 1 if no
    let state = Utils.exec('bash -c "pidof wlsunset > /dev/null; echo $?"')
    if (state == "0"){
        return true
    }
    else{
        return false
    }
}

function ToggleNightlight(self){ 
    self.toggleClassName("active-button", !isNightLightOn()) // Toggles active indicator
    nightLightOn.value = !isNightLightOn()
    Utils.execAsync(['bash', '-c', 'pkill wlsunset; if [ $? -ne 0 ]; then wlsunset -T 4010; fi']).catch(logError);
}

export const NightLightButton = (w, h) => Widget.Button({
    setup: (self) => {
        self.toggleClassName("active-button", isNightLightOn()) // Set active indicator state on startup
    },
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_primary_click: (self) => {
        ToggleNightlight(self)
    },
    child: Widget.Icon({
        class_name: "icon",
        icon: `nightlight-symbolic`,
    }),
})


export const BarIcon = () => Widget.Icon({
    size: 20,
    visible: nightLightOn.bind(),
    tooltip_text: "Night light is on",
    icon: "nightlight-symbolic",
})

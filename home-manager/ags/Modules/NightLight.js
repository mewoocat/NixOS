import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

const NightLightState = Variable(false, {
    // Check if wlsunset is running
    // Bash command outputs 0 if yes or 1 if no
    poll: [1000, 'bash -c "pidof wlsunset > /dev/null; echo $?"', out => {
        if (out == 0){
            return true
        }
        else{
            return false
        }
    }],
})


export async function ToggleNightlight(){ 
    execAsync(['bash', '-c', 'pkill wlsunset; if [ $? -ne 0 ]; then wlsunset -T 4010; fi']).catch(logError);
}

export const NightLightButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_primary_click: () => {
        ToggleNightlight()
    },
    child: Widget.Icon({
        class_name: "icon",
        icon: `nightlight-symbolic`,
    }),
    setup: self => self.hook(NightLightState, () => {
        self.toggleClassName("active-button", NightLightState.value)
    }),
})

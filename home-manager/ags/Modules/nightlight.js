import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const NightlightIcon = () => Widget.Box({
    child:
        Widget.Label({
            label: ""
        })
})

export async function ToggleNightlight(){
    console.log("meow")
    execAsync(['bash', '-c', 'pkill wlsunset; if [ $? -ne 0 ]; then wlsunset; fi']);
}
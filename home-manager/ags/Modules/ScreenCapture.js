
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const ScreenRecordButton = (w, h) => Widget.Button({
    class_name: `control-panel-button`,
    css: `
        min-width: ${w}rem;
        min-height: ${h}rem;
    `,
    on_clicked: () => {
        // Starts screen recorder if not running
        // Stops screen recorder if running
        execAsync(['bash', '-c', 'pkill wf-recorder; if [ $? -ne 0 ]; then wf-recorder -f ~/Screenrecordings/recording_"$(date +\'%b-%d-%Y-%I:%M:%S-%P\')".mp4; fi']).catch(logError);
    },
    /*
    child: Widget.Icon({
        size: 22,
        setup: self => {

        }
    })
    */ 
    child: Widget.Label({
        label: "",
    })
})

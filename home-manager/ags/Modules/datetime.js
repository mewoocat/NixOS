import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const Clock = () => Widget.Label({
    class_name: 'clock',
    setup: self => self
        // this is bad practice, since exec() will block the main event loop
        // in the case of a simple date its not really a problem
        //.poll(1000, self => self.label = exec('date "+%H:%M:%S %b %e."'))

        // this is what you should do
        .poll(1000, self => execAsync(['date', '+%B %e   %l:%M %P'])
            .then(date => self.label = date)),
});
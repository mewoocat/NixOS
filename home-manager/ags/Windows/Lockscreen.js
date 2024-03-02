
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';


const entry = Widget.Entry({
    placeholder_text: 'type here',
    text: '',
    visibility: false,
    onAccept: (self) => {
        Utils.authenticate(self.text)
            .then(() => {
                print('authentication sucessful')
                execAsync('ags -t Lockscreen-0')
                execAsync('ags -t bar-0')
            })
            .catch(err => {
                logError(err, 'unsucessful')
                self.text = ""
            })
    },
})

const contents = Widget.Box({
    class_name: "lockscreen",

    children: [
        Widget.Label({
            // Why this no worky :'(
            /*
            css: `
                min-width: 8rem;
                min-heigth: 8rem;
                background-color: red;
            `,
            */
            label: "password pls: "
        }),
        entry,
    ],
})

export const Lockscreen = (monitor = 0) => Widget.Window({
    name: `Lockscreen-${monitor}`, // name has to be unique
    monitor,
    visible: false,
    anchor: ['top', 'bottom', 'left', 'right'],
    exclusivity: 'exclusive',
    keymode: 'on-demand', //set to 'exclusive'
    child: contents,
});
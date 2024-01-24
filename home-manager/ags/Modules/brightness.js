
import Brightness from '../Services/brightness.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const brightness = () => Widget.Box({
    class_name: 'brightness',
    //css: 'min-width: 180px',
    children: [
        Widget.Label({
            //label: Brightness.bind('screen-value').transform(v => `${v}`),
            setup: self => self.hook(Brightness, (self, screenValue) => {
                // screenValue is the passed parameter from the 'screen-changed' signal
               // self.label = screenValue ?? 0;

                // NOTE:
                // since hooks are run upon construction
                // the passed screenValue will be undefined the first time

                // all three are valid
                //self.label = `${Brightness.screenValue}`;
                //self.label = `${Brightness.screen_value}`;
                //self.label = `${Brightness['screen-value']}`;
                self.label = ''

            }, 'screen-changed'),
        }),
        Widget.Slider({
            class_name: "sliders",
            hexpand: true,
            //min: 1,
            //max: 100,
            draw_value: false,
            on_change: self => Brightness.screen_value = self.value,
            value: Brightness.bind('screen-value'),
        }),
    ],
});
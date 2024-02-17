
import Brightness from '../Services/brightness.js'
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

export const brightness = () => Widget.Box({
    class_name: 'brightness',
    children: [
        Widget.Label({
            setup: self => self.hook(Brightness, (self, screenValue) => {
                self.label = ''

            }, 'screen-changed'),
        }),
        Widget.Slider({
            class_name: "sliders",
            hexpand: true,
            min: 0.01, // Set min slightly above 0 zero so the display can't be turned all the way off
            max: 1,
            draw_value: false,
            on_change: self => Brightness.screen_value = self.value,
            value: Brightness.bind('screen-value'),
        }),
    ],
});
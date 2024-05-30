
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

export const MicrophoneIcon = () => Widget.Button({
    class_name: "normal-button",
    child: Widget.Box({
        class_name: "microphone-icon icon",
        children:[
            Widget.Label().hook(Audio, self => {
                if (Audio.microphone.is_muted){
                    self.class_name = "dim"
                    self.label = ""
                }
                else{
                    self.label = ""
                    self.class_name = ""
                }
            
            }, 'microphone-changed'),
        ]
    })
})

export const MicrophoneSlider = () => Widget.Box({
    class_name: 'microphone',
    children: [
        MicrophoneIcon(),
        Widget.Slider({
            class_name: "sliders",
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.microphone.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.microphone?.volume || 0;
            }, 'microphone-changed'),
        }),
    ],
});

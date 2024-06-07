
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

export const MicrophoneIcon = () => Widget.Icon({
    size: 20,
    icon: "audio-input-microphone-high-symbolic",
}).hook(Audio, self => {
    if (Audio.microphone.is_muted){
        self.icon = "audio-input-microphone-muted-symbolic"
    }
    else{
        self.icon = "audio-input-microphone-high-symbolic"
    } 
}, 'microphone-changed')

export const MicrophoneButton = () => Widget.Button({
    class_name: "normal-button",
    child: MicrophoneIcon(),
})


export const MicrophoneSlider = () => Widget.Box({
    class_name: 'microphone',
    children: [
        MicrophoneButton(),
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

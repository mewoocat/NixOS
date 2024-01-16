
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

export const VolumeIcon = () => Widget.Box({
    class_name: "volume-icon icon",
    children:[
        Widget.Label().hook(Audio, self => {
            if (!Audio.speaker)
                return;

            //const icon = Audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            //    threshold => threshold <= Audio.speaker.volume * 100);

            console.log(Audio.speaker.volume)

            var icon = "vol-err";

            if (Audio.speaker.is_muted){
                icon = ""
            }
            else if(Audio.speaker.volume > 0.75){
                icon = ""
            }
            else if(Audio.speaker.volume > 0.50){
                icon = ""
            }
            else if(Audio.speaker.volume > 0.25){
                icon = ""
            }
            else{
                icon = ""
            }

            console.log(icon)

            self.label = icon;
        }, 'speaker-changed'),
    ]
})

export const VolumeSlider = () => Widget.Box({
    class_name: 'volume',
    css: 'min-width: 180px',
    children: [
        Widget.Icon().hook(Audio, self => {
            if (!Audio.speaker)
                return;

            const category = {
                101: 'overamplified',
                67: 'high',
                34: 'medium',
                1: 'low',
                0: 'muted',
            };

            const icon = Audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
                threshold => threshold <= Audio.speaker.volume * 100);

            self.icon = `audio-volume-${category[icon]}-symbolic`;
        }, 'speaker-changed'),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed'),
        }),
    ],
});
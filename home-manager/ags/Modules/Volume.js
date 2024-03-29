
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

export const VolumeIcon = () => Widget.Box({
    class_name: "volume-icon icon",
    children:[
        Widget.Overlay({
            //TODO Running a hook on both of these labels might be unnecessary
            child:
                Widget.Label().hook(Audio, self => {
                    self.class_name = "volume-bg"
                    if (Audio.speaker.is_muted){
                        self.label = ""
                    }
                    else{
                        self.label = ""
                    }
                
                }, 'speaker-changed'),

            overlays: [
                Widget.Label().hook(Audio, self => {
                    if (!Audio.speaker)
                        return;

                    var icon = "vol-err";

                    if (Audio.speaker.is_muted){
                        icon = "" // Only base icon of overlay is displayed
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

                    self.label = icon;
                }, 'speaker-changed'),
            ]
        })
    ]
})

export const VolumeSlider = () => Widget.Box({
    class_name: 'volume',
    //css: 'min-width: 180px',
    children: [
        VolumeIcon(),
        Widget.Slider({
            class_name: "sliders",
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed'),
        }),
    ],
});


import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Gtk from 'gi://Gtk'
import GObj from 'gi://GObject'
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import { ControlPanelTab } from '../variables.js';

import { GPUTemp } from '../variables.js';

export const VolumeIcon = () => Widget.Box({
    class_name: "icon",
    children:[
        Widget.Overlay({
            pass_through: true,
            //TODO Running a hook on both of these labels might be unnecessary
            child:
                Widget.Label().hook(Audio, self => {
                    self.class_name = "dim"
                    if (Audio.speaker.is_muted){
                        self.label = ""
                    }
                    else{
                        self.label = ""
                    }
                
                }, 'speaker-changed'),

            overlays: [
                Widget.Label({
                    
                }).hook(Audio, self => {

                    print("gpu " + GPUTemp.value)
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

export const VolumeButton = () => Widget.Button({
    class_name: "normal-button",
    onClicked: () => ControlPanelTab.setValue("volume"),
    child: VolumeIcon(),
})

export const VolumeSlider = () => Widget.Box({
    class_name: 'volume',
    //css: 'min-width: 180px',
    children: [
        VolumeButton(),
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

import { ComboBoxText } from '../Global.js';
const OutputDevices = ComboBoxText({})
OutputDevices.on("changed", self => {
    var streamID = OutputDevices.get_active_id()
    if (streamID == undefined){
        streamID = 1
    }
    Audio.speaker = Audio.getStream(parseInt(streamID))
})
OutputDevices.hook(Audio, self => {
    self.remove_all()
    // Set combobox with output devices
    for( let i = 0; i < Audio.speakers.length; i++ ){ 
        let device = Audio.speakers[i]
        self.append(device.id.toString(), device.stream.port)
    }
    OutputDevices.set_active_id(Audio.speaker.id.toString())
}, "speaker-changed")


function appVolume(app){
    //const level = Variable(app.volume)
    return Widget.Box({
        children: [
            Widget.Label(app.name),
            Widget.Slider({
                class_name: "sliders",
                hexpand: true,
                draw_value: false,
                on_change: ({ value }) => app.volume = value,
                value: app.bind("volume"),
            }),
        ]
    })
}

// Mixer
const mixer = Widget.Scrollable({
    css: 'min-height: 100px',
    child: Widget.Box({
        vertical: true,
        children: Audio.bind("apps").as(v => v.map(appVolume))
    })
})


// Volume menu
export const VolumeMenu = () => Widget.Box({
    vertical: true,
    children: [ 
        Widget.Label({
            label: "Outputs",
            hpack: "start",
        }),
        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        OutputDevices,

        Widget.Label({
            label: "Master",
            hpack: "start",
        }),
        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        VolumeSlider(),
        Widget.Label({
            label: "Mixer",
            hpack: "start",
        }),
        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        mixer,
    ],
})






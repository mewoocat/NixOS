import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Gtk from 'gi://Gtk'
import { ControlPanelTab } from '../variables.js';

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
    onClicked: () => ControlPanelTab.setValue("microphone"),
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


//let ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
import { ComboBoxText } from '../Global.js';
const inputDevices = ComboBoxText({
    //class_name: "normal-button",
})
inputDevices.on("changed", self => {
    var streamID = inputDevices.get_active_id()
    if (streamID == undefined){
        streamID = 1
    }
    Audio.microphone = Audio.getStream(parseInt(streamID))
})
inputDevices.hook(Audio, self => {
    self.remove_all()
    // Set combobox with output devices
    for( let i = 0; i < Audio.microphones.length; i++ ){ 
        let device = Audio.microphones[i]
        self.append(device.id.toString(), device.stream.port)
    }
    inputDevices.set_active_id(Audio.microphone.id.toString())
}, "microphone-changed")

// Volume menu
export const MicrophoneMenu = () => Widget.Box({
    vertical: true,
    children: [ 
        Widget.Label({
            label: "Inputs",
            hpack: "start",
        }),
        Widget.Separator({
            class_name: "horizontal-separator",
        }),
        inputDevices,
    ],
})

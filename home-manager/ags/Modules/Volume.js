
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Gtk from 'gi://Gtk'
import GObj from 'gi://GObject'
import { ControlPanelTab } from '../variables.js';

export const VolumeIcon = () => Widget.Button({
    class_name: "normal-button",
    onClicked: () => ControlPanelTab.setValue("audio"),
    child: Widget.Box({
        class_name: "volume-icon icon",
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

const ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
const OutputDevices = ComboBoxText({
    class_name: "normal-button",
})
OutputDevices.on("changed", self => {
    //print(OutputDevices.get_active_id())
})
OutputDevices.hook(Audio, self => {
    self.remove_all()
    // Set combobox with output devices
    for( let i = 0; i < Audio.speakers.length; i++ ){ 
        let device = Audio.speakers[i]
        self.append(device.name, device.stream.port)
    }
    OutputDevices.set_active_id(Audio.speaker.name)
}, "changed")

// Mic stuff
//const ComboBoxText = Widget.subclass(Gtk.ComboBoxText)
const inputDevices = ComboBoxText({
    class_name: "normal-button",
})
inputDevices.on("changed", self => {
    //print(inputDevices.get_active_id())
})
inputDevices.hook(Audio, self => {
    self.remove_all()
    // Set combobox with output devices
    for( let i = 0; i < Audio.microphones.length; i++ ){ 
        let device = Audio.microphones[i]
        self.append(device.name, device.stream.port)
    }
    inputDevices.set_active_id(Audio.microphone.name)
}, "changed")

// Volume menu
export const VolumeMenu = () => Widget.Box({
    vertical: true,
    children: [

        // Output device
        Widget.Label({
        }).hook(Audio, self => {
            self.label = "Output device: " + Audio.speaker.description
        }, "changed"),

        // Port 
        Widget.Label({
        }).hook(Audio, self => {
            try{
                self.label = "Port: " + Audio.speaker.stream.port
            }
            catch{
               self.label = "No port found" 
            }
        }, "changed"),

        OutputDevices,

        inputDevices,
    ],
})






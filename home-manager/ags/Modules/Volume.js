
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Gtk from 'gi://Gtk'
import GObj from 'gi://GObject'
import { ControlPanelTab } from '../variables.js';

export const VolumeIcon = () => Widget.Button({
    onClicked: () => ControlPanelTab.setValue("audio"),
    child: Widget.Box({
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


const ComboBox = Widget.subclass(Gtk.ComboBox)
const DeviceList = new Gtk.ListStore()
DeviceList.set_column_types([GObj.TYPE_STRING])
//Seems to be adding the items but the text color is the same as the bg color :/
DeviceList.set_value(DeviceList.append(), 0, "aaaaaa") 
DeviceList.set_value(DeviceList.append(), 0, "bbbbbb") 
DeviceList.set_value(DeviceList.append(), 0, "bbbbbb") 
DeviceList.set_value(DeviceList.append(), 0, "bbbbbb") 

const OutputDevices = ComboBox({
    class_name: "combobox",
    model: DeviceList,
})

const ohlord = new Gtk.ComboBoxText()
ohlord.append_text("aaa")
ohlord.append_text("bbb")

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
            self.label = "Port: " + Audio.speaker.stream.port
        }, "changed"),

        OutputDevices,
        ohlord,
    ],
})






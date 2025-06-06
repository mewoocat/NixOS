import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../Services" as Services

ColumnLayout {    
    anchors.fill: parent
    Slider {
        Layout.fillWidth: true
        Layout.fillHeight: true
        from: 0
        value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
        to: 1
    }
    Slider {
        Layout.fillWidth: true
        Layout.fillHeight: true
        from: 0
        value: Services.Brightness.value
        stepSize: 0.1
        onValueChanged: {
            Services.Brightness.value = value
        }
        to: 1

    }
}

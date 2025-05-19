import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "root:/Services/" as Services

ColumnLayout {    
    anchors.fill: parent
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Slider {
        Layout.fillWidth: true
        Layout.fillHeight: true
        from: 0
        value: Pipewire.defaultAudioSink.audio.volume
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

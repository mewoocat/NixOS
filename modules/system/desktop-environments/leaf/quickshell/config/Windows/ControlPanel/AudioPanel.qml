import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "root:/Services/" as Services

RowLayout {    
    implicitWidth: 200
    implicitHeight: 300
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Slider {
        from: 0
        value: Pipewire.defaultAudioSink.audio.volume
        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
        to: 1
    }
    Slider {
        from: 0
        value: Services.Brightness.value
        stepSize: 0.1
        onValueChanged: {
            Services.Brightness.value = value
        }
        to: 1

    }
}

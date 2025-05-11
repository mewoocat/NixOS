import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire

RowLayout {    
    implicitWidth: 200
    implicitHeight: 100
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Slider {
        from: 0
        value: Pipewire.defaultAudioSink.audio.volume
        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
        to: 1
    }
}

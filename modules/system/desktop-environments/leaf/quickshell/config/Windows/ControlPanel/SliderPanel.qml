import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../Services" as Services
import "../../Modules/Common" as Common

ColumnLayout {    
    anchors.fill: parent

    RowLayout {
        Common.NormalButton {
            iconName: Services.Audio.getIcon(Pipewire.defaultAudioSink)
            text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
        }
        Slider {
            Layout.fillWidth: true
            Layout.fillHeight: true
            from: 0
            value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
            onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
            to: 1
        }
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

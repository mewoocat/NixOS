import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls

RowLayout {
    Ctrls.Button {
        icon.name: Services.Audio.getIconName(Pipewire.defaultAudioSink)
        text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
        implicitWidth: icon.width + spacing + leftPadding + rightPadding + volumeTextMetrics.width
        onClicked: () => volumeExpander.expanded = true
        TextMetrics {
            id: volumeTextMetrics
            text: "100%"
            Component.onCompleted: console.log(`text metrics: ${width}`)
        }
    }
    Ctrls.Slider {
        Layout.fillWidth: true
        from: 0
        value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
        to: 1
    }
}

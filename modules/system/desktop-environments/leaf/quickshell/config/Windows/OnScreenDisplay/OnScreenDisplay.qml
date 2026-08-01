import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls

PanelWindow {
    width: bg.width
    height: bg.height
    anchors.bottom: true
    margins.bottom: 100
    color: "transparent"
    visible: Services.OSD.visible
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: 'quickshell-panel-' + 'osd'
    Rectangle {
        id: bg
        property int margins: 8
        width: row.width + row.margins * 2
        height: row.height + row.margins * 2
        color: "#bb212121"
        radius: Root.State.rounding
        RowLayout {
            id: row
            x: margins
            y: margins
            property int margins: 8
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
    }
}

pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetData { 
    id: widgetData
    name: "Audio and Brightness"
    xSize: 4
    ySize: 2
    component: WrapperRectangle {
        anchors.fill: parent
        color: "transparent"
        margin: 8

        ColumnLayout {

            // Volume
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

            // Brightness
            RowLayout {
                Ctrls.Button {
                    icon.name: Services.Brightness.getIcon()
                    text: Math.ceil(Services.Brightness.value * 100) + '%'
                    onClicked: () => brightnessExpander.expanded = true
                    implicitWidth: icon.width + spacing + leftPadding + rightPadding + brightnessTextMetrics.width
                    TextMetrics {
                        id: brightnessTextMetrics
                        text: "100%"
                    }
                }
                Ctrls.Slider {
                    Layout.fillWidth: true
                    from: 0.01
                    value: Services.Brightness.value
                    //stepSize: 0.01
                    onValueChanged: Services.Brightness.value = value
                    to: 1
                    onPressedChanged: () => {
                        if (!pressed) { Services.Brightness.setDDCCIBrightness(value * 100) }
                    }
                }
            }
        }
    }
}

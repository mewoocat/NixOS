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
import "../Pages" as Pages

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
                Shared.Expander {
                    id: volumeExpander
                    backgroundRadius: widgetData.radius
                    backgroundMargin: widgetData.padding
                    backdrop: widgetData.panelGrid
                    expandee: Ctrls.Button {
                        icon.name: Services.Audio.getIconName(Pipewire.defaultAudioSink)
                        text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
                        Layout.minimumWidth: 86
                        onClicked: () => volumeExpander.expanded = true
                    }
                    content: Pages.Audio {
                        onGoBack: volumeExpander.expanded = false
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
                Shared.Expander {
                    id: brightnessExpander
                    backgroundRadius: widgetData.radius
                    backgroundMargin: widgetData.padding
                    expandee: Ctrls.Button {
                        icon.name: Services.Brightness.getIcon()
                        text: Math.ceil(Services.Brightness.value * 100) + '%'
                        onClicked: () => brightnessExpander.expanded = true
                        Layout.minimumWidth: 86
                    }
                    content: Pages.Display {
                        onGoBack: brightnessExpander.expanded = false
                    }
                    backdrop: widgetData.panelGrid
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

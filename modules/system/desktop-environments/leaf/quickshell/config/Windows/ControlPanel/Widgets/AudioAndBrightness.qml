
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

AbsGrid.WidgetData { 
    name: "Audio and Brightness"
    xSize: 4
    ySize: 2
    component: WrapperRectangle {
        anchors.fill: parent
        color: "transparent"
        margin: 8

        ColumnLayout {    
            RowLayout {
                Ctrls.Button {
                    icon.name: Services.Audio.getIcon(Pipewire.defaultAudioSink)
                    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
                    onClicked: () => Root.State.controlPanelPage = 1
                    Layout.minimumWidth: 86
                }
                Ctrls.Slider {
                    Layout.fillWidth: true
                    from: 0
                    value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
                    onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
                    to: 1
                }
            }

            RowLayout {
                Ctrls.Button {
                    icon.name: Services.Brightness.getIcon()
                    text: Math.ceil(Services.Brightness.value * 100) + '%'
                    onClicked: () => Root.State.controlPanelPage = 4
                    Layout.minimumWidth: 86
                }
                Ctrls.Slider {
                    Layout.fillWidth: true
                    from: 0.01
                    value: Services.Brightness.value
                    //stepSize: 0.01
                    onValueChanged: Services.Brightness.value = value
                    to: 1
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules" as Modules
import "../../../Modules/Common" as Common
import "./Templates"

PageBase {
    pageName: "Audio" 
    content: ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        SectionBase { name: "Output"}

        // Default output
        Modules.MixerItem {
            implicitWidth: parent.width
            node: Pipewire.defaultAudioSink
        }


        // Output device selector
        ComboBox {
            id: comboBox
            implicitWidth: parent.width
            model: Services.Audio.outputDevices
                .map(n => n.description) // Map to just the output name string (Results in a list of string names)
                onActivated: (index) => { 
                    console.log(index)
                    Pipewire.preferredDefaultAudioSink = Services.Audio.outputDevices[index] // Set the audio output (untested)
                }
            /*
            delegate: WrapperMouseArea {
                Component.onCompleted: () => {
                    console.log(`------------------------------modelData: ${modelData.ready} - ${modelData.description} - stream? ${modelData.isStream}`)
                }
                id: item
                required property PwNode modelData
                Text {
                    color: palette.text
                    text: `name: ${item.modelData.name}`
                }
            }
            */
        }

        SectionBase { name: "Mixer"}

        WrapperRectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            Common.Scrollable {
                //implicitHeight: 100
                anchors.fill: parent

                // Track all nodes outputting to the default output
                // Useful for mixer entries
                PwNodeLinkTracker {
                    id: defaultOutputLinkTracker
                    node: Pipewire.defaultAudioSink
                }
                content: Repeater {
                    // For each source outputting to the default output
                    // i.e. Each program, etc.
                    // A link is a connection between two nodes
                    model: defaultOutputLinkTracker.linkGroups
                    Component.onCompleted: console.error(`link list: ${defaultOutputLinkTracker.list}`)

                    // MixerItem
                    Modules.MixerItem {}
                } 
            }
        }
    }
}

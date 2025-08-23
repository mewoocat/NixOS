import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Common as Common

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

        Common.Scrollable {
            // If some apps are outputting to the default output
            visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length > 0
            Layout.fillHeight: true
            Layout.fillWidth: true

            content: Repeater {
                // For each source outputting to the default output
                // i.e. Each program, etc.
                // A link is a connection between two nodes
                model: Services.Audio.defaultOutputLinkTracker.linkGroups
                delegate: Modules.MixerItem {}
            } 
        }
        
        // No mixer items placeholder
        Item {
            // If no apps are outputting to the default output
            visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length <= 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Text {
                anchors.centerIn: parent
                color: palette.placeholderText
                text: "Nothing to mix :/"
            }
        }
    }
}

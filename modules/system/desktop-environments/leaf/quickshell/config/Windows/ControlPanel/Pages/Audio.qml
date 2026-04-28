pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs as Root

PageBase {
    pageName: "Audio" 

    content: Shared.ScrollableView {
        id: scrollView
        anchors.fill: parent

        ColumnLayout {
            id: col
            implicitWidth: parent.width
            spacing: 0    

            SubSection { Layout.fillWidth: true; name: "Output" }

            // Default output
            Shared.MixerItem {
                node: Pipewire.defaultAudioSink
                name: node?.nickname ?? "no name"
                description: node?.properties["media.class"] ?? "no description"
            }

            // Output device selector
            Ctrls.ComboBox {
                id: comboBox
                implicitWidth: parent.width
                model: Services.Audio.outputDevices
                    .map(n => n.description) // Map to just the output name string (Results in a list of string names)
                onActivated: (index) => { 
                    console.log(index)
                    Pipewire.preferredDefaultAudioSink = Services.Audio.outputDevices[index] // Set the audio output (untested)
                }
            }

            SubSection { name: "Mixer" }
            
            Shared.ScrollableList {
                implicitWidth: parent.implicitWidth 
                visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length > 0
                // For each source outputting to the default output, i.e. Each program, etc.
                // A link is a connection between two nodes
                model: Services.Audio.defaultOutputLinkTracker.linkGroups
                delegate: Shared.MixerItem {
                    required property PwLinkGroup modelData
                    implicitWidth: parent?.width
                    linkGroup: modelData
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
}

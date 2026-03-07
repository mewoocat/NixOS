import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf

PageBase {
    pageName: "Audio" 


    component MixerItem: Leaf.ListItem {
        id: root
        //Layout.fillWidth: true
        //implicitHeight: 80
        implicitWidth: parent.width
        //color: "green"
        required property PwLinkGroup modelData
        property PwNode node: modelData.source // The source node
        delegate: ColumnLayout {
            id: column
            spacing: 0
            anchors.left: parent.left
            anchors.right: parent.right

            // Binding this node so all of its properties are available
            PwObjectTracker {
                objects: [ root.node ]
            }

            RowLayout {
                Layout.fillWidth: true
                IconImage {
                    implicitSize: 24
                    // For some reason application.icon-name is "", using .name instead
                    //source: Quickshell.iconPath(root.node.properties["application.icon-name"])
                    source: {
                        // If node is set and is bound
                        if (root.node && root.node.ready) {
                            const properties = root.node.properties
                            if (properties["application.name"] !== undefined) {
                                return Quickshell.iconPath(root.node.properties["application.name"].toLowerCase())
                            }
                        }
                        // fallback
                        return Quickshell.iconPath(Services.Audio.getIcon(Pipewire.defaultAudioSink))
                    }
                }
                // Source name
                Text {
                    Layout.fillWidth: true
                    color: Root.State.colors.on_surface
                    elide: Text.ElideRight
                    text: {
                        const text = root.node.properties["application.name"]
                        if (text === undefined) { return "n/a" }
                        return text
                    }
                }
            }

            // Debug
            /*
            Button {
                text: "text"
                onClicked: () => {
                    console.log(`app.icon-name: ${root.node.properties["application.icon-name"]}`)
                    console.log(`app.name: ${root.node.properties["application.name"]}`)
                    console.log(`media.name: ${root.node.properties["media.name"]}`)
                }
            }
            */

            Slider {
                Layout.fillWidth: true
                from: 0
                value: Services.Audio.getVolume(root.node)
                // Don't allow for value to be changed until node is bound
                onValueChanged: root.node.ready ? root.node.audio.volume = value : null
                to: 1
            }
        }
    }


    content: ColumnLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        SectionBase { name: "Output"}

        // Default output
        MixerItem {
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
                    color: Root.State.colors.on_surface_container
                    text: `name: ${item.modelData.name}`
                }
            }
            */
        }

        SectionBase { name: "Mixer"}
        
        /*
        Leaf.ListViewScrollable {
            // If some apps are outputting to the default output
            visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length > 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: palette.base

            // For each source outputting to the default output
            // i.e. Each program, etc.
            // A link is a connection between two nodes
            model: Services.Audio.defaultOutputLinkTracker.linkGroups
            mainDelegate: Modules.MixerItem {}
        }
        */
        Leaf.ListView {
            visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length > 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "red"
            // For each source outputting to the default output, i.e. Each program, etc.
            // A link is a connection between two nodes
            model: Services.Audio.defaultOutputLinkTracker.linkGroups
            delegate: MixerItem {}
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

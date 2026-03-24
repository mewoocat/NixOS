import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf
import qs.Components.Controls as Ctrls
import qs as Root

PageBase {
    pageName: "Audio" 


    component MixerItem: Leaf.ListItem {
        id: root
        //Layout.fillWidth: true
        //implicitHeight: 80
        implicitWidth: parent.width
        //color: "green"
        padding: 2
        margin: 2
        backgroundColor: root.interacted ? Root.State.colors.primary : "transparent"
        required property PwLinkGroup modelData
        property PwNode node: modelData.source // The source node
        property string name: ""
        property string description: ""
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
                    source: {
                        if (!root.node || !root.node.ready) {
                            return ""
                        }
                        // If node is set and is bound
                        const properties = root.node.properties
                        const iconName = properties["application.icon-name"] // Can be ""
                        const appName = properties["application.name"]
                        // First try the app icon-name
                        if (!iconName) {
                            // Passing in true for the second param will return an empty string if icon is not found
                            const iconAttempt = Quickshell.iconPath(iconName, true)
                            if (!iconAttempt) return iconAttempt
                        }
                        // If none is found try the app name
                        if (!appName) {
                            const nameAttempt = Quickshell.iconPath(appName.toLowerCase())
                            if (!nameAttempt) return nameAttempt
                        }
                        // fallback (generic volume level icon)
                        return Quickshell.iconPath(Services.Audio.getIcon(root.node))
                    }
                }
                ColumnLayout {
                    spacing: 0
                    Text {
                        Layout.fillWidth: true
                        color: root.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        elide: Text.ElideRight
                        text: {
                            if (root?.name) return root.name
                            if (root?.node?.description) return root.node.description
                            const appName = root?.node?.properties["application.name"]
                            if (appName) return appName
                            return "n/a"
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: {
                            if (root?.description) return root.description
                            if (root?.node?.properties["media.name"]) return root.node.properties["media.name"]
                            return "n/a"
                        }
                        elide: Text.ElideRight
                        color: root.interacted ? Root.State.colors.on_primary : Root.State.colors.on_surface
                        font.pointSize: 8
                        opacity: 0.6
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

            Ctrls.Slider {
                Layout.fillWidth: true
                value: Services.Audio.getVolume(root.node)
                // Don't allow for value to be changed until node is bound
                onValueChanged: root.node.ready ? root.node.audio.volume = value : null
            }
        }
    }


    content: Leaf.FlickScrollable {
        id: scrollable
        anchors.fill: parent
        contentPadding: 0
        showBackground: false

        content: ColumnLayout {
            anchors.fill: parent
            id: col
            spacing: 0
    
            SubSection { name: "Output"}

            // Default output
            MixerItem {
                implicitWidth: parent.width
                node: Pipewire.defaultAudioSink
                name: node?.nickname ?? "no name"
                description: node?.properties["media.class"] ?? "no description"
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

            SubSection { name: "Mixer"}
            
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
                implicitWidth: parent.implicitWidth 
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
}

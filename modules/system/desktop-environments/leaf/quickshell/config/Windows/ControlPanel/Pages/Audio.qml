pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.Services as Services
import qs.Modules.Leaf as Leaf
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared
import qs as Root

PageBase {
    pageName: "Audio" 

    component MixerItem: Ctrls.Button {
        id: root
        //implicitHeight: 80
        //color: "green"
        Layout.fillWidth: true
        padding: 2
        hoverEnabled: false
        property PwLinkGroup linkGroup
        property PwNode node: linkGroup.source // The source node
        property string name: ""
        property string description: ""
        contentItem: ColumnLayout {
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
                Shared.Icon {
                    source: {
                        if (!root.node || !root.node.ready) { return "" }
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

            Ctrls.Slider {
                Layout.fillWidth: true
                value: Services.Audio.getVolume(root.node)
                // Don't allow for value to be changed until node is bound
                onValueChanged: root.node.ready ? root.node.audio.volume = value : null
            }
        }
    }

    content: Shared.Scrollable {
        id: scrollView
        anchors.fill: parent

        ColumnLayout {
            id: col
            implicitWidth: parent.width
            spacing: 0    

            SubSection { Layout.fillWidth: true; name: "Output" }

            // Default output
            MixerItem {
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
            
            ListView {
                snapMode: ListView.SnapToItem
                implicitHeight: childrenRect.height// Defaults to as large as is needed to show all items
                implicitWidth: parent.implicitWidth 
                //keyNavigationEnabled: true // Enabled by default
                highlightMoveDuration: 0 // Instantly snaps to item
                clip: true // Ensure that scrolled items don't go outside the widget

                visible: Services.Audio.defaultOutputLinkTracker.linkGroups.length > 0
                // For each source outputting to the default output, i.e. Each program, etc.
                // A link is a connection between two nodes
                model: Services.Audio.defaultOutputLinkTracker.linkGroups
                delegate: MixerItem {
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

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../../../" as Root
import "../../../Services" as Services
import "../../../Modules/Common" as Common

ColumnLayout {
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }

    Slider {
        Layout.fillWidth: true
        from: 0
        value: Services.Audio.getVolume(Pipewire.defaultAudioSink)
        onValueChanged: Pipewire.defaultAudioSink.audio.volume = value
        to: 1
    }

    // Track all nodes outputting to the default output
    PwNodeLinkTracker {
        id: defaultOutputLinkTracker
        node: Pipewire.defaultAudioSink
    }

    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Repeater {
            // For each source outputting to the default output
            // i.e. Each program, etc.
            // A link is a connection between two nodes
            model: defaultOutputLinkTracker.linkGroups
            Component.onCompleted: console.error(`link list: ${defaultOutputLinkTracker.list}`)

            // MixerItem
            ColumnLayout {
                id: mixerItem
                required property PwLinkGroup modelData
                property PwNode node: modelData.source // The source node

                // Binding this node so all of its properties are available
                PwObjectTracker {
                    objects: [node]
                }

                RowLayout {
                    IconImage {
                        implicitSize: 24
                        // For some reason application.icon-name is "", using .name instead
                        //source: Quickshell.iconPath(mixerItem.node.properties["application.icon-name"])
                        source: Quickshell.iconPath(mixerItem.node.properties["application.name"])
                    }
                    // Source name
                    Text {
                        color: palette.text
                        text: `Source: ${mixerItem.node.name}`
                    }
                }
                Slider {
                    Layout.fillWidth: true
                    from: 0
                    value: Services.Audio.getVolume(mixerItem.node)
                    onValueChanged: mixerItem.node.audio.volume = value
                    to: 1
                }
            }
        }
    }

    Button {
        text: "test"
    }
}

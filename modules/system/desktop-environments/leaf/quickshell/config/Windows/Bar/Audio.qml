
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs as Root
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs.Services as Services
import Quickshell.Services.Pipewire

BarButton {
    id: buttonRoot
    icon.name: Services.Audio.getIconName(Pipewire.defaultAudioSink)
    text: Math.ceil(Services.Audio.getVolume(Pipewire.defaultAudioSink) * 100) + '%'
    ContextMenu.onRequested: () => popupWindow.visible = true

    property Shared.PopupWindow popupWindow: Shared.PopupWindow {
        id: root
        //visible: buttonRoot.hovered
        anchor {
            // Only window or item should be set at a time, otherwise a crash can occur
            item: buttonRoot
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Bottom | Edges.Left
        }

        content: ColumnLayout {
            Shared.ScrollableView {
                id: scrollView
                Layout.preferredHeight: col.height < 600 ? col.height : 600
                Layout.preferredWidth: 260

                ColumnLayout {
                    id: col

                    Shared.TextBlock {
                        text: "Sound"
                        font.bold: true
                    }
                    Shared.Seperator {
                        implicitHeight: 8
                        Layout.fillWidth: true
                    }

                    Shared.TextBlock {
                        padding: 8
                        text: "Output"
                        font.bold: true
                    }

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
                    Shared.Seperator {
                        implicitHeight: 8
                        Layout.fillWidth: true
                    }

                    Shared.TextBlock {
                        padding: 8
                        text: "Mixer"
                        font.bold: true
                    }
                    
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
    }
}

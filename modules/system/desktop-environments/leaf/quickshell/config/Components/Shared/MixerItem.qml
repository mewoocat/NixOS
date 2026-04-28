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

Ctrls.Button {
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
                source: Quickshell.iconPath(Services.Audio.getIconName(root.node))
                recolorIcon: false
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

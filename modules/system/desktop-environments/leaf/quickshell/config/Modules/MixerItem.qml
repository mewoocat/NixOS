import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../../" as Root
import "../Services" as Services

ColumnLayout {
    Layout.fillWidth: true
    id: root
    required property PwLinkGroup modelData
    property PwNode node: modelData.source // The source node

    // Binding this node so all of its properties are available
    PwObjectTracker {
        objects: [root.node]
    }

    RowLayout {
        Layout.fillWidth: true
        IconImage {
            implicitSize: 24
            // For some reason application.icon-name is "", using .name instead
            //source: Quickshell.iconPath(root.node.properties["application.icon-name"])
            source: Quickshell.iconPath(root.node.properties["application.name"])
        }
        // Source name
        Text {
            Layout.fillWidth: true
            color: palette.text
            elide: Text.ElideRight
            text: `Source: ${root.node.name}`
        }
    }
    Slider {
        Layout.fillWidth: true
        from: 0
        value: Services.Audio.getVolume(root.node)
        onValueChanged: root.node.audio.volume = value
        to: 1
    }
}

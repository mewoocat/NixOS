import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import "../../" as Root
import "../Services" as Services

Rectangle {
    //Layout.fillWidth: true
    implicitHeight: column.height
    implicitWidth: parent.width
    color: "transparent"
    //color: "red"
    id: root
    required property PwLinkGroup modelData
    property PwNode node: modelData.source // The source node
ColumnLayout {
    id: column
    anchors.left: parent.left
    anchors.right: parent.right

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
            source: {
                const properties = root.node.properties
                if (properties["application.name"] !== undefined) {
                    return Quickshell.iconPath(root.node.properties["application.name"].toLowerCase())
                }
                else {
                    return Quickshell.iconPath(Services.Audio.getIcon(Pipewire.defaultAudioSink))
                }
            }
        }
        // Source name
        Text {
            Layout.fillWidth: true
            color: palette.text
            elide: Text.ElideRight
            text:  root.node.properties["application.name"]
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
        onValueChanged: root.node.audio.volume = value
        to: 1
    }
}
}

import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property Item content
    margin: 4
    implicitWidth: {
        console.log(`scrollableItem parent width: ${parent.width}`)
        return parent.width
    }
    hoverEnabled: true
    
    Rectangle {
        id: background
        color: root.containsMouse ? palette.alternateBase : "transparent"
        radius: 24
        implicitWidth: parent.width - (parent.margin * 2)
        implicitHeight: content.height
        children: [
            content
        ]
    }
}

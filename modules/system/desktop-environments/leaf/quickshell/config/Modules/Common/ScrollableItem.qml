import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property Item content
    margin: 4
    implicitWidth: parent.width
    
    Rectangle {
        id: background
        color: "red"
        radius: 8
        implicitWidth: parent.width - (parent.margin * 2)
        implicitHeight: content.height
        children: [
            content
        ]
    }
}

import QtQuick
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property Item content
    rightMargin: 8 // Try to have this match the scrollbar width
    leftMargin: 8
    implicitWidth: parent.width
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

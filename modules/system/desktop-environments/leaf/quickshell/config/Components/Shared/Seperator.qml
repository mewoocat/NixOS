import QtQuick
import qs as Root

Item {
    height: Root.State.windowPadding * 2
    width: 100 // Default
    Rectangle {
        id: line
        anchors.centerIn: parent
        radius: 1
        implicitHeight: 2
        implicitWidth: parent.width
        color: Root.State.colors.on_surface
        opacity: 0.7
    }
}


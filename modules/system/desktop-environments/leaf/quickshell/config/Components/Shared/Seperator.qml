import QtQuick
import qs as Root

Item {
    height: Root.State.windowPadding * 2
    width: 100 // Default
    Rectangle {
        id: line
        anchors.centerIn: parent
        implicitHeight: 1
        implicitWidth: parent.width
        color: Root.State.colors.on_surface_variant
    }
}


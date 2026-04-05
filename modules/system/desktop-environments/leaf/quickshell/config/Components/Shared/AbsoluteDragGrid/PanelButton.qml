import QtQuick
import Quickshell
import qs as Root

MouseArea {
    id: root
    required property Component component
    hoverEnabled: true
    Rectangle {
        anchors.fill: parent
        color: root.containsMouse ? Root.State.colors.primary : "transparent"
        Loader {
            anchors.centerIn: parent
            sourceComponent: root.component
        }
    }
}

import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    implicitHeight: 48
    implicitWidth: 48
    color: "black"
    Rectangle {
        anchors.centerIn: parent
        implicitWidth: 20
        implicitHeight: 20
        radius: 8
        color: "red"
    }
}

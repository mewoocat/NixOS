import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../" as Root

Rectangle {
    radius: Root.State.rounding
    color: "red"
    Layout.fillWidth: true
    implicitHeight: 100
    Layout.maximumWidth: 600
    Layout.alignment: Qt.AlignHCenter
    //Layout.margins: 4
}

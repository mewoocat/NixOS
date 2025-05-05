import Quickshell
import Quickshell.Widgets
import QtQuick

MouseArea {
    id: mouseArea
    required property var action
    property string iconName: ""
    property string text: ""
    implicitWidth: 48
    implicitHeight: parent.height
    hoverEnabled: true
    onClicked: action()
    Rectangle {
        anchors.centerIn: parent
        implicitWidth: text.width
        implicitHeight: 32
        radius: 24
        color: mouseArea.containsMouse ? "grey" : "#00000000"
        Component.onCompleted: {
        }
        IconImage {
            visible: mouseArea.iconName != ""
            anchors.centerIn: parent
            implicitSize: 20
            source: Quickshell.iconPath(mouseArea.iconName)
        }
        Text {
            id: text
            visible: mouseArea.text != ""
            anchors.centerIn: parent
            color: "#ffffff"
            text: mouseArea.text
            font.pointSize: 12
        }
   }
}

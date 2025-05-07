import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects

MouseArea {
    id: mouseArea
    required property var action
    property string iconName: ""
    property string text: ""
    implicitWidth: box.width
    implicitHeight: parent.height
    hoverEnabled: true
    onClicked: action()
    Rectangle {
        id: box
        anchors.centerIn: parent
        //implicitWidth: iconName != "" ? icon.width + 16 : text.width + 16
        implicitWidth: icon.width + text.width + 16
        implicitHeight: 28
        radius: 24
        color: mouseArea.containsMouse ? "grey" : "#00000000"
        Component.onCompleted: {
        }
        IconImage {
            id: icon
            visible: mouseArea.iconName != ""
            anchors.verticalCenter: parent
            anchors.left: parent.left
            implicitSize: 20
            source: Quickshell.iconPath(mouseArea.iconName)
            // Recoloring icon
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1
                colorizationColor: "#ff0000"
            }
        }
        Text {
            id: text
            visible: mouseArea.text != ""
            anchors.right: parent.right
            anchors.horizontalCenter: parent
            color: "#ffffff"
            text: mouseArea.text
            font.pointSize: 12
        }
   }
}

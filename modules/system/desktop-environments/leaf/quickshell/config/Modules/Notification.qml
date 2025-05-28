import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

// Visual element to represent a single notification
MouseArea {
    id: root

    required property Notification notification
    
    //anchors.fill: parent
    //Layout.fillWidth: true
    implicitWidth: parent.width
    //implicitHeight: parent.height
    implicitHeight: 80
    enabled: true // Whether mouse events are accepted
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    onClicked: (event) => {
        switch(event.button) {
            case Qt.LeftButton:
                break
            case Qt.RightButton:
                break
            case Qt.MiddleButton:
                break
            default:
                console.log("button problem")
        }
    }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: 24
        color: root.containsMouse ? palette.highlight : "transparent"

        RowLayout {
            id: row
            height: parent.height
            spacing: 4
            IconImage {
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                id: icon
                implicitSize: 32
                source: Quickshell.iconPath(root.notification.appIcon)
            }
            Text {
                id: text
                Layout.alignment: Qt.AlignHCenter
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                text: root.notification.appName
                font.pointSize: 12
                color: palette.text
            }
        }
   }
}

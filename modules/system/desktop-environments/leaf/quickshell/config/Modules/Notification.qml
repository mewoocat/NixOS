import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications as QsNotifications
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import "../Services" as Services
import "../Modules/Common" as Common

// Visual element to represent a single notification
MouseArea {
    id: root

    required property var notification // Internal notification type
    property QsNotifications.Notification qsNotif: notification.notifObj // Quickshell notification
 
    implicitWidth: parent === null ? 1 : parent.width // Not sure why parent is null sometimes
    implicitHeight: 100

    drag.target: root
    drag.axis: Drag.XAxis

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
        clip: true
        id: box
        anchors {
            fill: parent
            margins: 8
        }
        radius: 12
        color: root.containsMouse ? palette.window : palette.button

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            RowLayout {
                id: row
                Layout.leftMargin: 8
                Layout.rightMargin: 8
                //Layout.topMargin: 8
                Layout.fillWidth: true
                spacing: 0
                width: 400
                height: 50

                // App icon
                IconImage {
                    id: appIcon
                    implicitSize: 16
                    source: {
                        let name = root.notification.appIcon
                        if (name === "") {
                            name = root.notification.appName.toLowerCase()
                        }
                        Quickshell.iconPath(name, "dialog-question")
                    }
                }
                // App name
                Text {
                    color: palette.text
                    font.pointSize: 8
                    text: root.notification.appName
                }
                // Spacer to push close button to right
                Rectangle {Layout.fillWidth: true;}

                Common.NormalButton {
                    implicitHeight: 32
                    //Layout.alignment: Qt.AlignRight // This no work?
                    iconName: 'gtk-close'
                    leftClick: root.notification.dismiss
                }
            }
            WrapperItem {
                margin: 8
                RowLayout {
                    spacing: 0
                    IconImage {
                        Layout.margins: 4
                        implicitSize: 32
                        source: root.notification.image
                    }
                    ColumnLayout {
                        Layout.leftMargin: 8
                        Text {
                            text: root.notification.summary
                            color: palette.text
                        }
                        Text {
                            text: root.notification.body
                            font.pointSize: 8
                            color: palette.text
                        }
                    }
                }
            }
        }
    }
}

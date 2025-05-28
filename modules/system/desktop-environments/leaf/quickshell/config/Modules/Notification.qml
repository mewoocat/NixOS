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
    
    implicitWidth: parent.width
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
            spacing: 0
            RowLayout {
                id: row
                height: parent.height
                spacing: 4
                Layout.leftMargin: 8
                Layout.topMargin: 8
                // App icon
                IconImage {
                    implicitSize: 16
                    source: {
                        let name = notification.appIcon
                        if (name === "") {
                            name = notification.appName.toLowerCase()
                        }
                        Quickshell.iconPath(name, "dialog-question")
                    }
                }
                // App name
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: palette.text
                    font.pointSize: 8
                    text: notification.appName
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
                            text: notification.summary
                            color: palette.text
                        }
                        Text {
                            text: notification.body
                            font.pointSize: 8
                            color: palette.text
                        }
                    }
                }
            }
        }
    }
}

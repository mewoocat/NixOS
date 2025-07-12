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
    implicitHeight: 116

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

    // Keep in mind that doing an anchor fill on a Wrapper will do an anchor fill on the child
    WrapperRectangle {
        clip: true
        id: box
        anchors {
            fill: parent
            margins: 8
        }
        radius: 12
        //color: root.containsMouse ? palette.window : palette.button
        color: palette.window
        margin: 8
        topMargin: 0 // Counteract the extra spacing for the close button

        // Wrap the layout in an item so that the layout doesn't get anchored to all corners
        // This would cause the layout to expand and space out it's children?
        Item {
            ColumnLayout {
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                implicitWidth: parent.width
                spacing: 0

                RowLayout {
                    id: row
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

                    // Close button
                    Common.NormalButton {
                        implicitHeight: 32
                        //Layout.alignment: Qt.AlignRight // This no work?
                        iconName: 'gtk-close'
                        leftClick: root.notification.dismiss
                    }
                }
                RowLayout {
                    //Layout.alignment: Qt.AlignTop
                    spacing: 0
                    IconImage {
                        //Layout.alignment: Qt.AlignTop
                        visible: root.notification.image != ""
                        Layout.margins: 4
                        implicitSize: 40
                        source: root.notification.image
                    }
                    ColumnLayout {
                        // Summary
                        Text {
                            Layout.fillWidth: true
                            text: root.notification.summary
                            elide: Text.ElideRight // Truncate with ... on the right
                            color: palette.text
                        }

                        // Body
                        Text {
                            Layout.fillWidth: true
                            text: root.notification.body
                            elide: Text.ElideRight // Truncate with ... on the right
                            font.pointSize: 8
                            color: palette.text
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }
    }
}

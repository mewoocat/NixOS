import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../../Modules/Common" as Common

// The animation jitters here, easy to see on linear easing
Rectangle {
    color: "transparent"
    id: root
    property int margin: 4
    property bool isExpanded: true
    property Item toggleButton: null
    implicitHeight: parent.height
    implicitWidth: trayBackground.width + root.margin
    property var toggle: () => root.isExpanded = !root.isExpanded
    Rectangle {
        id: trayBackground
        color: palette.base
        radius: 24
        anchors.centerIn: parent
        clip: true
        implicitHeight: parent.height - root.margin
        implicitWidth: root.isExpanded ? trayContent.width + root.margin * 2 : root.toggleButton.width + root.margin * 2
        Behavior on implicitWidth {
            PropertyAnimation { 
                duration: 300
                easing.type: Easing.InOutBack
            }
        }
        /* also works
        implicitWidth: trayContent.width + root.margin * 2
        state: isExpanded ? "default" : "hidden"
        states: [
            State {
                name: "default"
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: trayBackground
                    implicitWidth: 44
                }
            }
        ]
        transitions: [
            Transition {
                PropertyAnimation { property: "implicitWidth"; duration: 300 }
            }
        ]
        */

        RowLayout {
            id: trayContent
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: root.margin
            //anchors.centerIn: parent
            implicitHeight: parent.height

            // System tray items
            RowLayout {
                id: trayItems
                implicitHeight: parent.height
                
                Repeater {
                    model: SystemTray.items
                    Common.NormalButton {
                        required property SystemTrayItem modelData

                        id: button
                        iconSource: modelData.icon != undefined ? modelData.icon : ""
                        leftClick: modelData.activate
                        rightClick: menuAnchor.open

                        // Popup menu
                        QsMenuAnchor {
                            id: menuAnchor
                            //anchor.window: bar
                            anchor {
                                window: button.QsWindow.window
                                edges: Edges.Bottom | Edges.Left
                                // Get a rect for the popup that is relative to the button item
                                // The returned rect is then in the context of the window
                                rect: button.QsWindow.window.contentItem.mapFromItem(button, Qt.rect(0, 0, 0, 40))
                            }
                            menu: button.modelData.menu
                        }
                    }
                }

            }

            // Spacer
            Rectangle {
                implicitHeight: 18
                implicitWidth: 1
                radius: 16
            }

            // Toggle button
            Common.NormalButton {
                id: toggleButton
                iconItem.rotation: root.isExpanded ? 0 : 180
                leftClick: root.toggle
                iconName: "pan-start-symbolic"
                Component.onCompleted: root.toggleButton = toggleButton
            }
        }
    }
}

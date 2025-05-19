import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "root:/Modules/Ui" as Ui


RowLayout {
    id: root
    spacing: 0
    property var toggle: () => {
        if (tray.state === "hidden") {
            toggleButton.iconItem.rotation = 0
            tray.state = "default"
            trayBox.state = "default"
        }
        else {
            toggleButton.iconItem.rotation = 180
            tray.state = "hidden"
            trayBox.state = "hidden"
        }
    }
    Rectangle {
        id: trayBox
        implicitWidth: tray.width
        implicitHeight: tray.height
        color: "transparent"
        clip: true

        states: [
            State {
                name: "default"
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: trayBox
                    implicitWidth: 0
                }
            }
        ]
        transitions: [
            Transition {
                PropertyAnimation { property: "implicitWidth"; duration: 300 }
                //reversible: true
            }
        ]

        Rectangle {
            id: tray
            implicitWidth: trayItems.width
            implicitHeight: trayItems.height
            states: [
                State {
                    name: "default"
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: tray
                        x: toggleButton.x
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation { property: "x"; duration: 300 }
                    //reversible: true
                }
            ]
            // Background
            Rectangle {
                anchors.fill: parent
                color: "black"
                //radius: 12
            }
            RowLayout {
                id: trayItems
                spacing: 0
                /*
                Behavior on x {
                    PropertyAnimation { duration: 1000 }
                }
                */
                Repeater {
                    model: SystemTray.items
                    /*
                    model: ScriptModel {
                        values: [...SystemTray.items.values]
                    }
                    */
                    /*
                    IconImage {
                        source: modelData.icon
                        implicitSize: 18
                    }
                    */
                    Ui.NormalButton {
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
                            menu: modelData.menu
                        }
                    }
                }
            }
        }
    }
    Ui.NormalButton {
        id: toggleButton
        leftClick: root.toggle
        iconName: "pan-start-symbolic"

        // Animating rotation
        /*
        transitions: [
            Transition {
                PropertyAnimation { property: "rotation"; duration: 300 }
            }
        ]
        */
    }
}

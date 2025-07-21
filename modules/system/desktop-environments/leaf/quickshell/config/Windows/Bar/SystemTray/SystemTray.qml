import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../../../Modules/Common" as Common
import "../../../" as Root

// The animation jitters here, easy to see on linear easing. UPDATE: jittering fixed.  It was
// due to nesting the animated rectangle within another rectangle which wasn't animated.
// Found there was no need for the nested rectangles so they were combined
//
// TODO: Optimize by using only one popup window and lazyloading it
Rectangle {
    id: root
    property int internalMargin: 4
    property int externalMargin: 8
    property bool isExpanded: true // Whether tray is showing all it's contents
    property Item toggleButton: null // Reference to the to toggle button
    property var toggle: () => root.isExpanded = !root.isExpanded

    implicitHeight: parent.height - root.externalMargin
    implicitWidth: root.isExpanded ? trayContent.width : root.toggleButton.width

    color: palette.base
    radius: 24
    //anchors.centerIn: parent
    clip: true
    //implicitWidth: root.isExpanded ? 300 : 60
    Behavior on implicitWidth {
        PropertyAnimation { 
            duration: 500
            easing.type: Easing.InOutQuint
            //easing.type: Easing.InOutBack
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
        implicitHeight: parent.height
        spacing: 0

        // System tray items
        WrapperItem {
            margin: root.internalMargin
            RowLayout {
                id: trayItems
                implicitHeight: root.height - externalMargin
                spacing: 0
                
                Repeater {
                    model: SystemTray.items
                    Common.NormalButton {
                        required property SystemTrayItem modelData

                        id: button
                        buttonHeight: root.height - internalMargin * 2
                        iconSource: modelData.icon != undefined ? modelData.icon : ""
                        leftClick: modelData.activate
                        rightClick: () => popupWindow.visible = true
                        defaultInternalMargin: 0
                        iconSize: 16

                        property var popupWindow: Common.PopupWindow {
                            id: trayPopup

                            anchor {
                                // Only window or item should be set at a time, otherwise a crash can occur
                                //window: Root.State.controlPanel
                                item: button
                                edges: Edges.Bottom | Edges.Right
                                gravity: Edges.Bottom | Edges.Left
                                margins.top: 32
                            }

                            // Used to extract the menu items from the menu
                            QsMenuOpener {
                                id: menuOpener
                                menu: modelData.menu
                            }

                            content: ColumnLayout {
                                id: menu
                                Repeater {
                                    model: menuOpener.children
                                    delegate: Loader {
                                        required property QsMenuEntry modelData
                                        // This seems to be required when wrapping with a loader
                                        Layout.fillWidth: true // It appears that this propagates through the 
                                        active: true
                                        // These are the possible components that would need to be loaded here
                                        // They are only Components which define a type to be created, not actual
                                        // instances of the type
                                        // Event though it looks like these are creating the component, the Component type
                                        // here should be coercing it into a Component instead
                                        property Component menuSeperator: Rectangle {
                                            implicitHeight: 1
                                            implicitWidth: menu.width
                                        }
                                        property Component menuItem: MenuEntry { 
                                            entry: modelData
                                            //Layout.fillWidth: true // It appears that this propagates through the 
                                        }
                                        // The selected component is instantiated here
                                        sourceComponent: modelData.isSeparator ? menuSeperator : menuItem
                                    }
                                }

                                /*
                                Repeater {
                                    model: menuOpener.children
                                    delegate: MenuItem {
                                        required property QsMenuEntry modelData
                                        entry: modelData
                                    }
                                }
                                */

                                /*
                                Repeater {
                                    model: menuOpener.children
                                    MouseArea {
                                        required property QsMenuEntry modelData
                                        implicitHeight: background.height
                                        implicitWidth: row.width // Default to text's width
                                        Layout.fillWidth: true // But expand if allowed
                                        id: mouseArea
                                        enabled: true
                                        hoverEnabled: true

                                        Rectangle {
                                            id: background
                                            color: mouseArea.containsMouse ? palette.accent : "transparent"
                                            radius: Root.State.rounding
                                            implicitHeight: text.height
                                            implicitWidth: parent.width
                                            //Component.onCompleted: console.log(`blue width: ${implicitWidth}`) 
                                            RowLayout {
                                                id: row
                                                Text { 
                                                    id: text
                                                    color: palette.text
                                                    text: modelData.text
                                                }
                                            }
                                        }
                                    }
                                }
                                */
                                /*
                                Repeater {
                                    //Layout.fillWidth: true
                                    model: menuOpener.children
                                    delegate: Loader {
                                        required property QsMenuEntry modelData
                                        active: true
                                        // These are the possible components that would need to be loaded here
                                        // They are only Components which define a type to be created, not actual
                                        // instances of the type
                                        // Event though it looks like these are creating the component, the Component type
                                        // here should be coercing it into a Component instead
                                        property Component menuSeperator: Rectangle {
                                            implicitHeight: 1
                                            implicitWidth: menu.width
                                            //Layout.
                                        }
                                        property Component menuItem: Common.PopupMenuItem { 
                                            id: thing
                                            text: modelData.text
                                            action: () => {}
                                            iconName: modelData.icon
                                            Layout.fillWidth: true // It appears that this propagates through the 
                                        }
                                        // The selected component is instantiated here
                                        sourceComponent: modelData.isSeparator ? menuSeperator : menuItem

                                        //sourceComponent: Rectangle {
                                        //    Layout.fillWidth: true
                                        //    color: "blue"
                                        //    implicitHeight: 20
                                        //    implicitWidth: modelData.isSeparator ? 40 : 80
                                        //}
                                    }
                                }
                                */
                            }
                        }
                    }

                    // Using native/platform menu
                    /*
                    Common.NormalButton {
                        required property SystemTrayItem modelData

                        id: button
                        buttonHeight: root.height - internalMargin * 2
                        iconSource: modelData.icon != undefined ? modelData.icon : ""
                        leftClick: modelData.activate
                        rightClick: menuAnchor.open
                        defaultInternalMargin: 0
                        iconSize: 16

                        // Popup menu
                        QsMenuAnchor {
                            id: menuAnchor
                            //anchor.window: bar
                            anchor {
                                window: button.QsWindow.window
                                edges: Edges.Bottom | Edges.Right
                                // Get a rect for the popup that is relative to the button item
                                // The returned rect is then in the context of the window
                                rect: button.QsWindow.window.contentItem.mapFromItem(button, Qt.rect(-20, 16, 0, 0))
                            }
                            menu: button.modelData.menu
                        }
                    }
                    */
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
            buttonHeight: root.height
            iconItem.rotation: root.isExpanded ? 0 : 180
            leftClick: root.toggle
            iconName: "pan-start-symbolic"
            leftInternalMargin: 4
            rightInternalMargin: 4
            Component.onCompleted: root.toggleButton = toggleButton
            Behavior on implicitWidth {

            }
        }
    }
}

pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Components.Shared as Shared
import qs.Components.Controls as Ctrls
import qs as Root

// The animation jitters here, easy to see on linear easing. UPDATE: jittering fixed.  It was
// due to nesting the animated rectangle within another rectangle which wasn't animated.
// Found there was no need for the nested rectangles so they were combined
//
// TODO: Optimize by using only one popup window and lazyloading it
ClippingRectangle {
    id: root
    property int margin: 4
    property bool isExpanded: true // Whether tray is showing all it's contents
    property Item toggleButton: null // Reference to the to toggle button
    property var toggle: () => root.isExpanded = !root.isExpanded

    implicitHeight: parent.height - root.margin * 2
    implicitWidth: root.isExpanded ? trayContent.width : root.toggleButton.width
    color: Root.State.colors.surface_container
    radius: height
    clip: true
    Behavior on implicitWidth {
        PropertyAnimation { 
            duration: 500
            easing.type: Easing.InOutQuint
            //easing.type: Easing.InOutBack
        }
    }

    RowLayout {
        id: trayContent
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        implicitHeight: parent.height
        spacing: 0

        // System tray items
        ClippingRectangle {
            clip: true
            radius: 16
            implicitWidth: trayItemsContainer.width
            implicitHeight: trayItemsContainer.height
            color: "transparent"
            Item {
                id: trayItemsContainer
                implicitWidth: trayItems.width
                implicitHeight: trayItems.height
                Rectangle {
                    visible: false
                    parent: root
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    radius: 16
                    implicitWidth: trayItems.width + 8
                    color: "red"
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.7; color: "transparent" }
                    }
                }

                ListView {
                    id: trayItems
                    property int numItems: SystemTray.items.values.length
                    property int maxNumItems: 8
                    implicitHeight: root.height //- root.externalMargin
                    //TODO: get tray button width instead of hard coding it
                    implicitWidth: numItems < maxNumItems ? 32 * numItems : 32 * maxNumItems
                    orientation: ListView.Horizontal
                    layoutDirection: Qt.RightToLeft
                    model: SystemTray.items

                    delegate: Ctrls.Button {
                        id: button
                        inset: 2
                        required property SystemTrayItem modelData
                        implicitHeight: trayItems.height
                        contentItem: IconImage {
                            implicitSize: 16
                            source: button.modelData?.icon ?? Qt.url("")
                        }
                        onClicked: modelData.activate
                        ContextMenu.onRequested: () => popupWindow.visible = true

                        // Used to extract the menu items from the menu
                        property QsMenuOpener menuOpener: QsMenuOpener {
                            id: menuOpener
                            menu: button.modelData.menu
                        }

                        property TrayPopupMenu popupWindow: TrayPopupMenu {
                            id: trayPopup
                            menuHandle: button.modelData.menu
                            parentButton: button
                            
                            anchor {
                                // Only window or item should be set at a time, otherwise a crash can occur
                                item: button
                                edges: Edges.Bottom | Edges.Right
                                gravity: Edges.Bottom | Edges.Left
                            }
                        }
                    }
                }

                // Gradient to indicate scrollable
                /*
                Rectangle {
                    anchors.fill: parent
                    visible: false
                    radius: 12
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0; color: "#77000000" }
                        GradientStop { position: 0.3; color: "transparent" }
                    }
                }
                */

                // Capture all mouse events for custom handling
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    enabled: true
                    onPressed: (event) => {
                        console.log(`pressed`)
                        event.accepted = false // Propagate click events
                    }
                    onWheel: (event) => {
                        console.log(`wheel ${event.angleDelta.x}, ${event.angleDelta.y}`)
                        if (event.angleDelta.y > 0 || event.angleDelta.x > 0) {
                            trayItems.flick(400, 0)
                        }
                        else if (event.angleDelta.y < 0 || event.angleDelta.x < 0) {
                            trayItems.flick(-400, 0)
                        }
                        else {

                        }
                        event.accepted = true // Don't propagate event
                    }
                }
            }
        }

        // Toggle button
        Ctrls.Button {
            id: toggleButton
            inset: 2
            contentItem.rotation: root.isExpanded ? 0 : 180
            onClicked: () => root.toggle()
            icon.name: "pan-start-symbolic"
            Component.onCompleted: root.toggleButton = toggleButton
        }
    }
}

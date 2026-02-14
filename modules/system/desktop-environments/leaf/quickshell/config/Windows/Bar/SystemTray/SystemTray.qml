//pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Modules.Common as Common
import qs as Root

// The animation jitters here, easy to see on linear easing. UPDATE: jittering fixed.  It was
// due to nesting the animated rectangle within another rectangle which wasn't animated.
// Found there was no need for the nested rectangles so they were combined
//
// TODO: Optimize by using only one popup window and lazyloading it
ClippingRectangle {
    id: root
    property int internalMargin: 4
    property int externalMargin: 8
    property bool isExpanded: true // Whether tray is showing all it's contents
    property Item toggleButton: null // Reference to the to toggle button
    property var toggle: () => root.isExpanded = !root.isExpanded

    implicitHeight: parent.height - root.externalMargin
    implicitWidth: root.isExpanded ? trayContent.width : root.toggleButton.width

    color: Root.State.colors.surface_container

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
        ClippingRectangle {
            clip: true
            radius: 16
            implicitWidth: trayItemsContainer.width
            implicitHeight: trayItemsContainer.height
            color: "transparent"
        WrapperItem {
            id: trayItemsContainer
            margin: root.internalMargin 
            // Allow for vertical scrolling (i.e. normal mouses) to horizontally scroll
            /*
            onWheel: (event) => {
                //console.log(`wheel ${event.angleDelta.x}, ${event.angleDelta.y}`)
                if (!trayItems.flicking) {
                    if (event.angleDelta.y > 0) {
                        trayItems.flick(300, 0)
                    }
                    else {
                        trayItems.flick(-300, 0)
                    }
                }
                event.accepted = true
            }
            */
            Item {
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
                        GradientStop { position: 1.0; color: "#77000000" }
                    }
                }
                ListView {
                    id: trayItems
                    property int numItems: SystemTray.items.values.length
                    property int maxNumItems: 8
                    implicitHeight: root.height - root.externalMargin
                    //implicitWidth: 32 * 4 //TODO: get tray button width instead of hard coding it
                    implicitWidth: numItems < maxNumItems ? 32 * numItems : 32 * maxNumItems
                    orientation: ListView.Horizontal
                    layoutDirection: Qt.RightToLeft
                    model: SystemTray.items

                    /*
                    ScrollBar.horizontal: ScrollBar {
                        id: scrollBar
                        implicitHeight: 1
                        parent: trayItems.parent
                        anchors.left: trayItems.left
                        anchors.top: trayItems.bottom
                        anchors.right: trayItems.right
                    }
                    */
                    
                    // Can't get this to work :(
                    /*
                    WheelHandler {
                        enabled: true
                        property: "contentX"
                        onWheel: console.log(`wheel`)
                    }
                    */

                    // Also doesn't work?
                    /*
                    focus: true
                    Keys.onPressed: (event) => {
                        console.log(`key`)
                        if (event.key == Qt.Key_Escape) {
                            console.log('escape')
                        }
                    }
                    */

                    delegate: Common.NormalButton {
                        id: button
                        required property SystemTrayItem modelData
                        buttonHeight: root.height - root.internalMargin * 2
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
                                menu: button.modelData?.menu
                            }

                            content: ColumnLayout {
                                id: menu
                                Repeater {
                                    model: menuOpener.children
                                    //onModelChanged: console.log("menuOpener.children: " + menuOpener.children.values)
                                    delegate: Loader {
                                        id: loader
                                        required property QsMenuEntry modelData
                                        //onModelDataChanged: console.log(`modelData: ${modelData}`)
                                        // This seems to be required when wrapping with a loader
                                        Layout.fillWidth: true // It appears that this propagates through the 
                                        active: true
                                        // These are the possible components that would need to be loaded here
                                        // They are only Components which define a type to be created, not actual
                                        // instances of the type
                                        // Event though it looks like these are creating the element, the Component type
                                        // here should be coercing it into a Component instead
                                        property Component menuSeperator: Rectangle {
                                            implicitHeight: 1
                                            implicitWidth: menu.width
                                            color: "#44ffffff"
                                        }
                                        property Component menuItem: BoundComponent {
                                            property QsMenuEntry entry: loader.modelData
                                            sourceComponent: MenuEntry {}
                                            //Layout.fillWidth: true // It appears that this propagates through the 
                                        }
                                        // The selected component is instantiated here
                                        sourceComponent: modelData.isSeparator ? menuSeperator : menuItem
                                    }
                                }
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
        }

        /*
        // System tray items
        WrapperItem {
            margin: root.internalMargin
            RowLayout {
                id: trayItems
                implicitHeight: root.height - root.externalMargin
                spacing: 0
                
                Repeater {
                    model: SystemTray.items

                    // Using native/platform menu
                    //Common.NormalButton {
                    //    required property SystemTrayItem modelData

                    //    id: button
                    //    buttonHeight: root.height - internalMargin * 2
                    //    iconSource: modelData.icon != undefined ? modelData.icon : ""
                    //    leftClick: modelData.activate
                    //    rightClick: menuAnchor.open
                    //    defaultInternalMargin: 0
                    //    iconSize: 16

                    //    // Popup menu
                    //    QsMenuAnchor {
                    //        id: menuAnchor
                    //        //anchor.window: bar
                    //        anchor {
                    //            window: button.QsWindow.window
                    //            edges: Edges.Bottom | Edges.Right
                    //            // Get a rect for the popup that is relative to the button item
                    //            // The returned rect is then in the context of the window
                    //            rect: button.QsWindow.window.contentItem.mapFromItem(button, Qt.rect(-20, 16, 0, 0))
                    //        }
                    //        menu: button.modelData.menu
                    //    }
                    //}
                }
            }
        }
        */

        // Spacer
        /*
        Rectangle {
            implicitHeight: 18
            implicitWidth: 1
            radius: 16
        }
        */

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

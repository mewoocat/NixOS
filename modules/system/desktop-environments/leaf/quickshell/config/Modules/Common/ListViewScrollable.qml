import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

// Size of root element must be set when consumed
Rectangle {
    id: root
    required property var model // The model that has the data to render for each item
    required property Component delegate // The type to render each item with, must have a var modelData property
    property int padding: 16
    property int animationSpeed: 100
    property ListView listViewRef: listView

    required property Component mainDelegate
    required property Component subDelegate

    property ScrollableItem prevExpandedItem: null // Holds ref to previously expanded item, for collapsing it when expanded item changed
    property ScrollableItem expandedItem: null // Holds a ref to the currently expanded item in this scrollable, or null if none are expanded
    onExpandedItemChanged: {
        if (prevExpandedItem != null) {
            prevExpandedItem.expanded = false
        }
        prevExpandedItem = expandedItem
    }
    onVisibleChanged: { // Whenever this is hidden, reset the expanded state if applicable
        if (!visible && expandedItem != null) {
            expandedItem.expanded = false
        }
    }
    color: "transparent" //"#770000ff"
    radius: 8
    clip: true

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    ScrollBar {
        id: scrollBar
        implicitWidth: 4
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    // List
    ListView {
        id: listView

        anchors {
            margins: root.padding
            fill: parent
        }

        ScrollBar.vertical: scrollBar
        snapMode: ListView.SnapToItem
        //keyNavigationEnabled: true // Enabled by default
        highlightMoveDuration: 0 // Instantly snaps to item
        clip: true // Ensure that scrolled items don't go outside the widget

        model: root.model

        delegate: WrapperMouseArea {
            id: scrollableItem
            //required property var parentScrollable // can't be typed as ListViewScrollable or else cyclical dep error
            //required property Item content
            //property var bgColorHighlight: palette.alternateBase
            //property var bgColor: "transparent"
            //property Component subContent: null
            property bool expanded: false
            property bool showBackground: false
            property int contentMargin: 0
            property Item subContentLoader: Loader {
                visible: active // To unreserve space when the component isn't loaded
                active: false
                sourceComponent: root.subContent
            }
            property bool interacted: root.containsMouse || root.focus // Indicates if active via mouse or focus
            bottomMargin: 8 // Yes, this will cause extra spacing at the bottom of the scrollable
            implicitWidth: parent ? parent.width : 0 // Idk why but parent is sometimes null here.  Maybe when this delegate is removed from the view?
            hoverEnabled: true

            /*
            onExpandedChanged: {
                if (expanded) {
                    if (parentScrollable.expandedItem != null) {
                        parentScrollable.expandedItem.expanded = false
                    }
                    parentScrollable.expandedItem = root
                }
                else {
                    parentScrollable.expandedItem = null
                }
            }
            */

            // scrollable item content
            Rectangle {
                id: background
                clip: true
                color: root.containsMouse || root.showBackground || root.focus ? root.bgColorHighlight : root.bgColor
                radius: 8
                implicitWidth: parent.width
                implicitHeight: root.content.height
                // Main content
                WrapperRectangle {
                    id: mainBox
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "transparent"
                    margin: root.contentMargin
                    Loader {
                        sourceComponent: root.mainDelegate
                    }
                }
                // Sub content
                WrapperRectangle {
                    id: subBox
                    anchors.top: mainBox.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "transparent"
                    margin: root.contentMargin
                    Loader {
                        sourceComponent: root.mainDelegate
                    }
                }

                /*
                onHeightChanged: console.log(`height: ${height}`)
                Behavior on implicitHeight {
                    PropertyAnimation { 
                        duration: 500
                        easing.type: Easing.InOutQuint
                    }
                }
                */
            }

            // Probably simpler to do this with a "Behavior" on instead of using states and transitions 
            states: [
                State {
                    name: "expanded"
                    when: root.expanded
                    PropertyChanges {
                        target: root.subContentLoader
                        active: true
                    }
                    PropertyChanges {
                        target: background
                        implicitHeight: mainBox.height + subBox.height

                    }
                }
            ]
            transitions: [
                // Expanding
                Transition {
                    from: ""; to: "expanded"
                    SequentialAnimation {
                        PropertyAction {
                            target: root
                            property: "showBackground"
                            value: true
                        }
                        PropertyAction {
                            target: root.subContentLoader
                            property: "active"
                            value: true
                        }
                        PropertyAnimation {
                            target: background
                            property: "implicitHeight"
                            duration: 350
                            easing.type: Easing.InOutQuad
                        }
                    }
                },
                // Collapsing
                Transition {
                    from: "expanded"; to: ""
                    SequentialAnimation {
                        PropertyAnimation {
                            target: background
                            property: "implicitHeight"
                            duration: 350
                            easing.type: Easing.InOutQuad
                        }
                        PropertyAction {
                            target: root.subContentLoader
                            property: "active"
                            value: false
                        }
                        PropertyAction {
                            target: root
                            property: "showBackground"
                            value: false
                        }
                    }
                }
            ]    
        }
        // Animations 
        // TODO: They work but need to set them up to look nice :)
        /*
        add: Transition {
            NumberAnimation {
                properties: "y"
                from: -100
                duration: root.animationSpeed
            }
        }
        addDisplaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: root.animationSpeed
            }
        }
        remove: Transition {
            SequentialAnimation {
                NumberAnimation {
                    properties: "x"
                    to: -8
                    duration: 100
                }
                NumberAnimation {
                    properties: "y"
                    to: -100
                    duration: root.animationSpeed
                }
            }
        }
        */
    }
}

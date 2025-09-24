import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property Item parentScrollable
    required property Item content
    property Component subContent: null
    property bool expanded: false
    property bool showBackground: false
    property Item subContentLoader: Loader {
        visible: active // To unreserve space when the component isn't loaded
        active: false
        sourceComponent: root.subContent
    }
    rightMargin: 8 // Try to have this match the scrollbar width
    leftMargin: 8
    topMargin: 4
    bottomMargin: 4
    implicitWidth: parent.width
    hoverEnabled: true

    function toggleExpand(): void {
        // Toggle the expansion for this item
        root.state = expanded ? "" : "expanded" // note that "" is the default state
        expanded = !expanded

        const prevExpandedItem = root.parentScrollable.expandedItem
        if (prevExpandedItem !== null && prevExpandedItem !== root) {
            prevExpandedItem.state = ""
            prevExpandedItem.expanded = false
        }
        if (expanded) {
            root.parentScrollable.expandedItem = root
        }
    }

    // Probably simpler to do this with a "Behavior" on instead of using states and transitions 
    states: [
        State {
            name: "expanded"
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
    
    Rectangle {
        id: background
        clip: true
        color: root.containsMouse || root.showBackground ? palette.alternateBase : "transparent"
        radius: 8
        implicitWidth: parent.width
        implicitHeight: root.content.height
        WrapperRectangle {
            id: mainBox
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"
            children: [ 
                root.content,
            ]
        }
        WrapperRectangle {
            id: subBox
            anchors.top: mainBox.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: "transparent"
            margin: 8
            children: [ 
                root.subContentLoader
            ]
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
}

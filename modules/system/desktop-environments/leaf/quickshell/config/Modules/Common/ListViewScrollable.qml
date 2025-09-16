import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Size of root element must be set when consumed
Rectangle {
    id: root
    required property var model // The model that has the data to render for each item
    required property Component delegate // The type to render each item with, must have a var modelData property
    property int padding: 16
    property int animationSpeed: 100
    property Item listViewRef: listView
    color: "transparent" //"#770000ff"
    radius: 8
    clip: true

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    ScrollBar {
        id: scrollBar
        implicitWidth: 4
        //implicitHeight: parent.height - 40
        //x: parent.width - width - (listView.anchors.margins / 2)
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: (root.padding - width) / 2
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
        keyNavigationEnabled: true
        //highlightMoveDuration: 0

        model: root.model
        delegate: root.delegate

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

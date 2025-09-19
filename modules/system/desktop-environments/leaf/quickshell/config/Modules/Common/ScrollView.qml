import QtQuick
import QtQuick.Controls
import Quickshell

// Size of root element must be set when consumed
Rectangle {
    id: root
    required property Item content
    property int padding: 16
    color: "#770000ff"
    radius: 8
    clip: true

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    ScrollBar {
        id: scrollBar
        implicitWidth: 10
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: 20 //(root.padding - width) / 2
        }
        /*
        background: Rectangle {
            color: "red"
            implicitHeight: 100
            implicitWidth: 4
        }
        */
    }

    Flickable {
        id: scrollView

        anchors {
            margins: root.padding
            fill: parent
        }

        //ScrollBar.vertical: scrollBar
        //ScrollBar.horizontal: null
        ScrollBar.vertical: ScrollBar {}
        ScrollBar.horizontal: ScrollBar {}
        contentWidth: 400//root.content.width
        contentHeight: 1000//root.content.height
        Component.onCompleted: {
            console.log(`content: ${root.content}`)
            console.log(`${contentWidth} x ${contentHeight}`)
        }

        /*
        children: [ root.content ]
        */
        children: [
            Rectangle {
                color: "green"
                implicitWidth: 400
                implicitHeight: 1000
            }
        ]
    }
}

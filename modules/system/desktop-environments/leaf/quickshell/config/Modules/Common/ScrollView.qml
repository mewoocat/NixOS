import QtQuick
import QtQuick.Controls
import Quickshell

// Size of root element must be set when consumed
Rectangle {
    id: root
    default property list<Item> content
    property int padding: 16
    color: "#770000ff"
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
            margins: (root.padding - width) / 2
        }
    }

    ScrollView {
        id: scrollView

        anchors {
            margins: root.padding
            fill: parent
        }

        ScrollBar.vertical: scrollBar

        contentData: root.content

    }
}

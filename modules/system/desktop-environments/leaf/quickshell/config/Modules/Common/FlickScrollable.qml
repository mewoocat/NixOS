import QtQuick
import QtQuick.Controls
import Quickshell

// Size of root element must be set when consumed
Control {
    id: root
    required property Item content
    property Item expandedItem: null
    // need to set the content's parent to the flickable 
    // ... might be a bug why it doesn't happen automatically if setting it in the children
    onContentChanged: content.parent = flickable.contentItem
    background: Rectangle {
        anchors.fill: parent
        color: "#77aa0000"
        radius: 8
    }
    padding: 12
    clip: true
    onHoveredChanged: scrollBar.visible = hovered

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
            //margins: (root.padding - width) / 2
        }
    }

    Flickable {
        id: flickable

        anchors {
            margins: root.padding
            fill: parent
        }

        ScrollBar.vertical: scrollBar
        contentWidth: root.content.width
        contentHeight: root.content.height
        // The only way I found that works to set the width of the content to the flickable
        onWidthChanged: root.content.implicitWidth = width
        //children: [ root.content ] // For some reason doesn't auto set the content's parent to the flickable's contentItem prop
    }
}

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs as Root
import qs.Modules.Leaf as Leaf

// Size of root element must be set when consumed
// why tf is this a control? be normal
Control {
    id: root
    default property Item content: null
    property Item expandedItem: null
    property int contentPadding: 0
    property bool showBackground: false;

    padding: 0
    onHoveredChanged: scrollBar.visible = hovered

    // Rendered floating as to not affect placement of list items.
    // So the width of the scroll bar must be less than the spacing between the edge of
    // the ListView and parent
    Leaf.LeafScrollBar {
        id: scrollBar
        anchors {
            left: root.right
            top: root.top
            bottom: root.bottom
        }
    }

    contentItem: Flickable {
        id: flickable
        anchors.fill: parent
        clip: true

        ScrollBar.vertical: scrollBar

        // The dimensions of the surface controlled by the Flickable
        contentWidth: parent.width
        contentHeight: box.implicitHeight // Increase the height of the scrolled surface to account for the padding pushing the content down

        // The only way I found that works to set the width of the content to the flickable
        onWidthChanged: root.content.implicitWidth = width
        //children: [ root.content ] // For some reason doesn't auto set the content's parent to the flickable's contentItem prop

        Rectangle {
            id: box
            color: "transparent"
            implicitWidth: parent.width
            implicitHeight: root.content.height
            children: [ root.content ]
        }
    }

    background: Rectangle {
        visible: root.showBackground
        anchors.fill: parent
        color: Root.State.colors.surface_container
        radius: Root.State.rounding
    }
}

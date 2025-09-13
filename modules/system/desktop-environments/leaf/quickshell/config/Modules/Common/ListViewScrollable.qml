import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Size of root element must be set when consumed
Rectangle {
    id: root
    required property ObjectModel model // The model that has the data to render for each item
    required property Component delegate // The type to render each item with, must have a var modelData property
    color: "#770000ff"
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
            margins: 8
        }
    }

    // List
    ListView {
        id: listView

        anchors {
            margins: 16
            fill: parent
        }

        ScrollBar.vertical: scrollBar

        model: root.model
        delegate: root.delegate
    }
}

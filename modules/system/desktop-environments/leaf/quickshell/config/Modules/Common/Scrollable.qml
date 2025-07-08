import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import '../../' as Root

Rectangle {
    id: root
    required property Item content
    color: "#77000000"
    radius: 8

    ScrollBar {
        id: scrollBar
        parent: root
        anchors.left: scrollView.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        policy: ScrollBar.AlwaysOn // Doesn't work?
    }

    // Content
    ScrollView {
        implicitWidth: parent.width - scrollBar.width
        id: scrollView
        anchors.right: scrollView.left
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        ScrollBar.vertical: scrollBar

        contentChildren: [ root.content ]
        /*
        contentChildren: [ 
            WrapperRectangle {
                color: "blue"
                children: [ root.content ]
            }
        ]
        */
        /*
        contentChildren: Rectangle {
            implicitHeight: childrenRect.height
            implicitWidth: scrollView.width - scrollBar.width
            color: "transparent"

            children: [ root.content ]
        }
        */
    }
}

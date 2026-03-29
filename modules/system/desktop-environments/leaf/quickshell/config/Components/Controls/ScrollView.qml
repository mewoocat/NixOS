import QtQuick
import QtQuick.Controls

ScrollView {
    id: control
    anchors.fill: parent
    //property list<QtObject> data: []
    Component.onCompleted: console.debug(`data: ${control.data[0]}`)
    /*
    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        hoverEnabled: true
        policy: ScrollBar.Always
        anchors {
            left: scrollView.right
            top: scrollView.top
            bottom: scrollView.bottom
        }
        contentItem: Rectangle {
            visible: scrollBar.size < 1.0 // Hide if scroll bar is fully expanded meaning it's container's size allow for all it's elements to be visible
            implicitWidth: scrollBar.hovered || scrollBar.active ? 8 : 4
            //implicitHeight: scrollBar.visualSize // Height seems to be auto set
            radius: 8
            opacity: scrollBar.hovered || scrollBar.active ? 0.6 : 0.3
            color: Root.State.colors.on_surface
        }
    }
    */
    Flickable {
        anchors.margins: 0
        anchors.fill: parent
        clip: true

        // The dimensions of the surface controlled by the Flickable
        contentWidth: control.width //- 16
        contentHeight: control.height //- 16
        children: control.children
    }
}

import QtQuick
import QtQuick.Controls
import qs as Root

ScrollBar {
    id: scrollBar
    hoverEnabled: true
    policy: ScrollBar.AsNeeded
    contentItem: Rectangle {
        visible: scrollBar.size < 1.0 // Hide if scroll bar is fully expanded meaning it's container's size allow for all it's elements to be visible
        implicitWidth: scrollBar.hovered || scrollBar.active ? 8 : 4
        //implicitHeight: scrollBar.visualSize // Height seems to be auto set
        radius: 8
        opacity: scrollBar.hovered || scrollBar.active ? 0.6 : 0.3
        color: Root.State.colors.on_surface
    }
}

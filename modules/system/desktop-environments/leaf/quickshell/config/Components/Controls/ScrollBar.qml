import QtQuick
import QtQuick.Controls
import qs as Root

ScrollBar {
    id: control
    property int maxBarWidth: 8
    property int minBarWidth: 4
    hoverEnabled: true
    policy: ScrollBar.AsNeeded
    implicitWidth: implicitContentWidth
    contentItem: Item {
        implicitWidth: 8
        //implicitHeight: scrollBar.visualSize // Height seems to be auto set
        Rectangle {
            anchors.centerIn: parent
            visible: control.size < 1.0 // Hide if scroll bar is fully expanded meaning it's container's size allow for all it's elements to be visible
            implicitWidth: control.hovered || control.active ? control.maxBarWidth : control.minBarWidth
            implicitHeight: parent.height
            radius: width / 2
            opacity: control.hovered || control.active ? 0.6 : 0.3
            color: Root.State.colors.on_surface
            Behavior on implicitWidth {
                PropertyAnimation { 
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
        }
    }
}

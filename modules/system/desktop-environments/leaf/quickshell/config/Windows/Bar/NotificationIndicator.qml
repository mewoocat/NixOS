import QtQuick
import Quickshell
import qs.Services as Services
import qs as Root

Rectangle {
    id: root
    implicitWidth: text.width < text.height ? text.height : text.width
    implicitHeight: text.height
    radius: height
    color: Root.State.colors.red_source
    visible: Services.Notifications.amount > 0
    Text {
        id: text
        topPadding: 2
        bottomPadding: 1
        leftPadding: 5
        rightPadding: 5
        anchors.centerIn: parent
        text: Services.Notifications.amount
        font.pointSize: 9
        font.weight: Font.DemiBold
        color: Root.State.colors.on_surface
    }
}

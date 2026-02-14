import QtQuick
import Quickshell
import qs.Services as Services
import qs as Root

Rectangle {
    id: root
    property int numNotifications:  Services.Notifications.notifications.length
    implicitWidth: text.width < 24 ? 24 : text.width
    implicitHeight: 24
    radius: 24
    color: Root.State.colors.red_source
    visible: numNotifications > 0
    Text {
        id: text
        padding: 4
        anchors.centerIn: parent
        text: root.numNotifications
        font.pointSize: 10
        color: Root.State.colors.on_red
    }
}

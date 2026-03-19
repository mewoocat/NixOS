import QtQuick
import Quickshell
import qs.Services as Services
import qs as Root

Rectangle {
    id: root
    implicitWidth: text.width < 24 ? 24 : text.width
    implicitHeight: 24
    radius: 24
    color: Root.State.colors.red_source
    visible: Services.Notifications.amount > 0
    Text {
        id: text
        padding: 4
        anchors.centerIn: parent
        text: Services.Notifications.amount
        font.pointSize: 10
        color: Root.State.colors.on_red
    }
}

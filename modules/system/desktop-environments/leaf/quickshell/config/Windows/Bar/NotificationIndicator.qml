import QtQuick
import Quickshell
import qs.Services as Services

Rectangle {
    id: root
    property int numNotifications:  Services.Notifications.notifications.length
    implicitWidth: text.width < 24 ? 24 : text.width
    implicitHeight: 24
    radius: 24
    color: "red"
    visible: numNotifications > 0
    Text {
        id: text
        padding: 4
        anchors.centerIn: parent
        text: root.numNotifications
        font.pointSize: 10
        color: palette.text
    }
}

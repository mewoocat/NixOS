import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "root:/Services" as Services
import "root:/Modules" as Modules


ListView {
    model: Services.Notifications.notifications
    anchors.fill: parent
    delegate: Modules.Notification {
        Layout.fillWidth: true
        required property var modelData
        notification: modelData
    }
}

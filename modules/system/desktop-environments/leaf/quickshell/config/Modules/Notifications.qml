import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications as QsNotifications
import "../Services" as Services
import "../Modules" as Modules

ListView {
    model: Services.Notifications.notificationModel
    anchors.fill: parent
    flickDeceleration: 0.00001
    maximumFlickVelocity: 10000
    clip: true // Ensure that scrolled items don't go outside the widget
    keyNavigationEnabled: true
    ScrollBar.vertical: ScrollBar { }
    delegate: Modules.Notification {
        Layout.fillWidth: true
        required property var modelData
        notification: modelData
    }
}

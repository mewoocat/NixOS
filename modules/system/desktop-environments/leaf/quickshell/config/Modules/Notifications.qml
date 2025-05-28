import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "root:/Services" as Services
import "root:/Modules" as Modules

ListView {
    model: Services.Notifications.notifications
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

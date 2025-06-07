import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications as QsNotifications
import "../Services" as Services
import "../Modules" as Modules

ColumnLayout {
    anchors.margins: 8
    anchors.fill: parent
    Text {
        Layout.fillWidth: true
        text: "Notifications"
        color: palette.text
    }
    // Horizontal line
    Rectangle {
        color: palette.text
        Layout.fillWidth: true
        implicitHeight: 1
        opacity: 0.2
    }
    ListView {
        Layout.fillHeight: true
        Layout.fillWidth: true
        model: Services.Notifications.notificationModel
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
}

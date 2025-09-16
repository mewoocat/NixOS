import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications as QsNotifications
import qs.Services as Services
import qs.Modules as Modules
import "./Common" as Common

// A widget to list all tracked notifications
ColumnLayout {
    anchors.margins: 16
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
    Common.Scrollable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: Services.Notifications.notifications.length > 0
        color: "transparent"
        model: Services.Notifications.notificationModel
        delegate: Modules.Notification {
            required property var modelData
            //Layout.fillWidth: true
            notification: modelData
        }
    }

    // No notification placeholder
    Item {
        visible: Services.Notifications.notifications.length <= 0
        Layout.fillHeight: true
        Layout.fillWidth: true
        Text {
            anchors.centerIn: parent
            color: palette.placeholderText
            text: "All caught up :)"
        }
    }
}

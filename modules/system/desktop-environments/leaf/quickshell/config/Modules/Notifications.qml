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
    // Old ListView impl
    /*
    ListView {
        visible: Services.Notifications.notifications.length > 0
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
    */
    Common.Scrollable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: Services.Notifications.notifications.length > 0
        color: "transparent"
        content: Repeater {
            model: Services.Notifications.notificationModel
            Modules.Notification {
                Layout.fillWidth: true
                required property var modelData
                notification: modelData
            }
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

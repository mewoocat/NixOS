import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Notifications as QsNotifications
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf
import qs as Root

// A widget to list all tracked notifications
ColumnLayout {
    anchors.margins: 16
    anchors.fill: parent
    Text {
        Layout.fillWidth: true
        text: "Notifications"
        color: Root.State.colors.on_surface
    }
    // Horizontal line
    Rectangle {
        color: Root.State.colors.on_surface_variant
        Layout.fillWidth: true
        implicitHeight: 1
        opacity: 0.2
    }
    Leaf.ListViewScrollable {
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: Services.Notifications.notifications.length > 0
        color: "transparent"
        model: Services.Notifications.notificationModel
        mainDelegate: Modules.Notification {
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
            color: Root.State.colors.on_surface_variant
            text: "All caught up :)"
        }
    }
}

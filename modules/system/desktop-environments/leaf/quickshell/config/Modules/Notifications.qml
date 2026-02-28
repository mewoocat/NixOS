pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Modules as Modules
import qs.Modules.Leaf as Leaf
import qs as Root

// A widget to list all tracked notifications
ColumnLayout {
    anchors.margins: 16 // TODO: Move to PanelItem?
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
    Leaf.ListView {
        id: notifListView
        Layout.fillHeight: true
        Layout.fillWidth: true
        visible: Services.Notifications.notifications.values.length > 0
        color: "transparent"
        model: Services.Notifications.notifications
        delegate: Notification {
            required property var modelData
            Component.onCompleted: console.debug(modelData)
            data: modelData
            listView: notifListView // A Required property
        }
    }

    // No notification placeholder
    Item {
        visible: Services.Notifications.notifications.values.length <= 0
        Layout.fillHeight: true
        Layout.fillWidth: true
        Text {
            anchors.centerIn: parent
            color: Root.State.colors.on_surface_variant
            text: "All caught up :)"
        }
    }
}

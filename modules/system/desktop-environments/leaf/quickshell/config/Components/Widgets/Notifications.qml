pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.Services as Services
import qs.Components.Shared as Shared
import qs as Root
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

// A widget to list all tracked notifications
AbsGrid.WidgetData {
    id: root
    uid: `notifications-${xSize}x${ySize}`
    name: "Notifications"
    xSize: 6
    ySize: 6
    component: ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.padding
        Shared.TextBlock {
            Layout.fillWidth: true
            text: "Notifications"
            color: Root.State.colors.on_surface
        }
        // Horizontal line
        Shared.HorizontalLine {}
        Shared.ScrollableList {
            id: notifListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: Services.Notifications.notifications.values.length > 0
            color: "transparent"
            model: Services.Notifications.notifications
            delegate: Shared.Notification {
                required property var modelData
                Component.onCompleted: console.debug(modelData)
                implicitWidth: notifListView.width
                notifData: modelData
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
}

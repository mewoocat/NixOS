pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications //as QsNotifications

Singleton {
    id: root

    property var notifications: server.trackedNotifications // ObjectModel<Notification> for all tracked notifications
    property ScriptModel notificationPopups: ScriptModel {} // ScriptModel<Notification> for notifications which are popped up

    function enable() {
        //console.log("enabling notifications")
    }

    // Listens for notifications
    NotificationServer {
        id: server

        actionIconsSupported: true
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        persistenceSupported: true

        // When a notification is received
        onNotification: (notif) => {
            notif.tracked = true // 
            console.log(`notif: ${notif.id}`)
            root.notificationPopups.values.push(notif)

            // Only show 3 popups max at a time
            if (root.notificationPopups.length > 3) {
                root.notificationPopups.splice(3, root.notificationPopups.length - 1)
            }

            console.debug(`notifcationPopus: ${root.notificationPopups.values}`)
        }
    }
}
